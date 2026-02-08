part of 'exam_questions_cubit.dart';

@immutable
abstract class ExamQuestionsState {}

class ExamQuestionsInitial extends ExamQuestionsState {}

class ExamQuestionsLoading extends ExamQuestionsState {}

class ExamQuestionsSuccess extends ExamQuestionsState {
  final ExamDetailsModel examDetails;
  ExamQuestionsSuccess(this.examDetails);
}

class ExamQuestionsError extends ExamQuestionsState {
  final String errMessage;
  ExamQuestionsError(this.errMessage);
}

class ExamSubmissionLoading extends ExamQuestionsState {}

class ExamSubmissionSuccess extends ExamQuestionsState {}

class ExamSubmissionError extends ExamQuestionsState {
  final String errMessage;
  ExamSubmissionError(this.errMessage);
}
