part of 'lesson_exams_cubit.dart';

@immutable
abstract class LessonExamsState {}

class LessonExamsInitial extends LessonExamsState {}

class LessonExamsLoading extends LessonExamsState {}

class LessonExamsSuccess extends LessonExamsState {
  final List<StudentExamEntity> exams;
  LessonExamsSuccess(this.exams);
}

class LessonExamsError extends LessonExamsState {
  final String errMessage;
  LessonExamsError(this.errMessage);
}
