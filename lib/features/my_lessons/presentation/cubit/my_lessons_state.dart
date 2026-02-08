part of 'my_lessons_cubit.dart';

@immutable
abstract class MyLessonsState {}

class MyLessonsInitial extends MyLessonsState {}

class MyLessonsLoading extends MyLessonsState {}

class MyLessonsSuccess extends MyLessonsState {
  final List<MyLessonModel> lessons;
  MyLessonsSuccess(this.lessons);
}

class MyLessonsError extends MyLessonsState {
  final String errMessage;
  MyLessonsError(this.errMessage);
}
