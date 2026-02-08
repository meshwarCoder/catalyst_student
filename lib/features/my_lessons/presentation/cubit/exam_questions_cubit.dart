import 'package:bloc/bloc.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_details_model.dart';
import 'package:catalyst/features/my_lessons/data/repo/exam_questions_repo.dart';
import 'package:meta/meta.dart';

part 'exam_questions_state.dart';

class ExamQuestionsCubit extends Cubit<ExamQuestionsState> {
  final ExamQuestionsRepo examQuestionsRepo;

  ExamQuestionsCubit(this.examQuestionsRepo) : super(ExamQuestionsInitial());

  Future<void> getExamQuestions(int examId) async {
    emit(ExamQuestionsLoading());
    final result = await examQuestionsRepo.getExamQuestions(examId);
    result.fold(
      (failure) => emit(ExamQuestionsError(failure.errMessage)),
      (examDetails) => emit(ExamQuestionsSuccess(examDetails)),
    );
  }

  Future<void> submitExam(
    int examId,
    List<Map<String, dynamic>> answers,
  ) async {
    emit(ExamSubmissionLoading());
    final result = await examQuestionsRepo.submitExam(examId, answers);
    result.fold(
      (failure) => emit(ExamSubmissionError(failure.errMessage)),
      (_) => emit(ExamSubmissionSuccess()),
    );
  }
}
