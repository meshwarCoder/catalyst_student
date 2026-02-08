import 'package:catalyst/features/my_lessons/data/repo/my_lessons_repo_impl.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_state.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllCoursesCubit extends Cubit<GetAllCoursesState> {
  GetAllCoursesCubit(this.coursesRepoImpl, this.myLessonsRepoImpl)
    : super(GetAllCoursesInitial());
  final CoursesRepoImpl coursesRepoImpl;
  final MyLessonsRepoImpl myLessonsRepoImpl;

  void getAllCourses() async {
    emit(GetAllCoursesLoading());

    // Fetch all courses
    final coursesResult = await coursesRepoImpl.getAllCourses();
    // Fetch my courses
    final myLessonsResult = await myLessonsRepoImpl.getMyLessons();

    coursesResult.fold(
      (failure) => emit(GetAllCoursesError(message: failure.errMessage)),
      (courses) {
        myLessonsResult.fold(
          (failure) {
            // If fetching my lessons fails, just show all courses as not joined
            emit(GetAllCoursesSuccess(courses: courses));
          },
          (myLessons) {
            // Create a set of joined lesson IDs for efficient lookup
            final joinedIds = myLessons.map((e) => e.id).toSet();

            // Update the isJoined flag for each course
            final updatedCourses = courses.map((course) {
              return course.copyWith(isJoined: joinedIds.contains(course.id));
            }).toList();

            emit(GetAllCoursesSuccess(courses: updatedCourses));
          },
        );
      },
    );
  }
}
