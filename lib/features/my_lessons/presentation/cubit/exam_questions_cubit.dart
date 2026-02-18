import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/utils/time_service.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_details_model.dart';
import 'package:catalyst/features/my_lessons/data/repo/exam_questions_repo.dart';
import 'package:meta/meta.dart';

part 'exam_questions_state.dart';

class ExamQuestionsCubit extends Cubit<ExamQuestionsState> {
  final ExamQuestionsRepo examQuestionsRepo;
  Timer? _timer;
  int _remainingSeconds = 0;
  final Map<int, dynamic> _answers = {};
  bool _isSubmitting = false;
  final Stopwatch _stopwatch = Stopwatch();

  ExamQuestionsCubit(this.examQuestionsRepo) : super(ExamQuestionsInitial());

  DateTime get _now => getIt<TimeService>().now;

  Future<void> getExamQuestions(int examId) async {
    emit(ExamQuestionsLoading());

    // Security Check: Block if already submitted
    final isSubmitted = await CacheHelper.getData(
      key: 'exam_submitted_$examId',
    );
    if (isSubmitted != null && isSubmitted == true) {
      emit(ExamQuestionsError("You have already submitted this exam."));
      return;
    }

    final result = await examQuestionsRepo.getExamQuestions(examId);
    await result.fold(
      (failure) async {
        emit(ExamQuestionsError(failure.errMessage));
      },
      (examDetails) async {
        if (!getIt<TimeService>().hasSynced) {
          emit(
            ExamQuestionsError(
              "A security check is required. Please check your internet connection and try again.",
            ),
          );
          return;
        }

        final now = _now;
        final startDateTime = DateTime.tryParse(examDetails.examDateTime);
        final endDateTime = examDetails.closingDate != null
            ? DateTime.tryParse(examDetails.closingDate!)
            : null;

        if (startDateTime != null && now.isBefore(startDateTime)) {
          emit(ExamQuestionsError("Exam has not started yet."));
          return;
        }

        if (endDateTime != null && now.isAfter(endDateTime)) {
          emit(ExamQuestionsError("Exam has already finished."));
          return;
        }

        await _initializeTimer(examDetails);

        if (_remainingSeconds <= 0) {
          emit(ExamQuestionsError("Time's up! You cannot enter this exam."));
          return;
        }

        emit(
          ExamQuestionsSuccess(
            examDetails: examDetails,
            remainingSeconds: _remainingSeconds,
            answers: Map.from(_answers),
          ),
        );
      },
    );
  }

  Future<void> _initializeTimer(ExamDetailsModel exam) async {
    _timer?.cancel();
    final startTimeKey = 'exam_start_time_${exam.id}';
    final savedStartTime = await CacheHelper.getData(key: startTimeKey);

    DateTime startTime;
    if (savedStartTime == null) {
      startTime = _now;
      await CacheHelper.saveData(
        key: startTimeKey,
        value: startTime.toIso8601String(),
      );
    } else {
      startTime = DateTime.parse(savedStartTime as String);
    }

    final now = _now;
    final closingDate = exam.closingDate != null
        ? DateTime.tryParse(exam.closingDate!)
        : null;

    final elapsedSeconds = now.difference(startTime).inSeconds;
    final remainingByDuration = (exam.durationMinutes * 60) - elapsedSeconds;

    if (closingDate != null) {
      final remainingByDeadline = closingDate.difference(now).inSeconds;
      _remainingSeconds = max(0, min(remainingByDuration, remainingByDeadline));
    } else {
      _remainingSeconds = max(0, remainingByDuration);
    }

    if (_remainingSeconds > 0) {
      _startTimer(exam, _remainingSeconds);
    }
  }

  void _startTimer(ExamDetailsModel exam, int initialRemainingSeconds) {
    _timer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatch.start();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = _stopwatch.elapsed.inSeconds;
      final currentRemaining = initialRemainingSeconds - elapsed;
      _remainingSeconds = currentRemaining;

      if (currentRemaining > 0) {
        if (state is ExamQuestionsSuccess) {
          final successState = state as ExamQuestionsSuccess;
          emit(
            ExamQuestionsSuccess(
              examDetails: successState.examDetails,
              remainingSeconds: currentRemaining,
              answers: Map.from(_answers),
            ),
          );
        }
      } else {
        _timer?.cancel();
        _stopwatch.stop();
        _submitOnTimeout(exam.id);
      }
    });
  }

  void updateAnswer(int questionId, dynamic value) {
    if (_remainingSeconds <= 0 || _isSubmitting) return;

    _answers[questionId] = value;
    if (state is ExamQuestionsSuccess) {
      final successState = state as ExamQuestionsSuccess;
      emit(
        ExamQuestionsSuccess(
          examDetails: successState.examDetails,
          remainingSeconds: _remainingSeconds,
          answers: Map.from(_answers),
        ),
      );
    }
  }

  Future<void> _submitOnTimeout(int examId) async {
    if (_isSubmitting) return;
    await submitCurrentAnswers(examId);
  }

  Future<void> submitCurrentAnswers(int examId) async {
    if (state is ExamQuestionsSuccess) {
      final successState = state as ExamQuestionsSuccess;
      final submissionData = _prepareSubmission(
        successState.examDetails.questions,
      );
      await submitExam(examId, submissionData);
    }
  }

  List<Map<String, dynamic>> _prepareSubmission(List<QuestionModel> questions) {
    return questions.map((q) {
      final answer = _answers[q.id];
      if (q.type == 'MCQ' || q.type == 'TRUE_FALSE') {
        return {
          "questionId": q.id,
          "selectedOptions": answer != null && answer is int ? [answer] : [],
          "textAnswer": null,
        };
      } else {
        return {
          "questionId": q.id,
          "selectedOptions": [],
          "textAnswer": answer?.toString(),
        };
      }
    }).toList();
  }

  Future<void> submitExam(
    int examId,
    List<Map<String, dynamic>> answers,
  ) async {
    if (_isSubmitting && state is! ExamQuestionsSuccess) {
      // already submitting from timeout or user click
    } else {
      _isSubmitting = true;
    }

    _timer?.cancel();
    emit(ExamSubmissionLoading());
    final result = await examQuestionsRepo.submitExam(examId, answers);
    result.fold(
      (failure) {
        _isSubmitting = false;
        emit(ExamSubmissionError(failure.errMessage));
      },
      (success) async {
        _isSubmitting = false;
        // Persist submission status locally
        await CacheHelper.saveData(key: 'exam_submitted_$examId', value: true);
        emit(ExamSubmissionSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
