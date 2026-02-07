import 'package:catalyst/features/teachers%20corses/data/models/get_all_courses_model.dart';

class GetAllCoursesState {}

final class GetAllCoursesInitial extends GetAllCoursesState {}

final class GetAllCoursesLoading extends GetAllCoursesState {}

final class GetAllCoursesSuccess extends GetAllCoursesState {
  final List<Lesson> courses;

  GetAllCoursesSuccess({required this.courses});
}

final class GetAllCoursesError extends GetAllCoursesState {
  final String message;

  GetAllCoursesError({required this.message});
}
