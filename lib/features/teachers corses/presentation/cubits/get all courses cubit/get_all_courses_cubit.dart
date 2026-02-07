import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_state.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllCoursesCubit extends Cubit<GetAllCoursesState> {
  GetAllCoursesCubit(this.coursesRepoImpl) : super(GetAllCoursesInitial());
  final CoursesRepoImpl coursesRepoImpl;

  void getAllCourses() async {
    emit(GetAllCoursesLoading());
    final result = await coursesRepoImpl.getAllCourses();
    result.fold(
      (failure) => emit(GetAllCoursesError(message: failure.errMessage)),
      (courses) => emit(GetAllCoursesSuccess(courses: courses)),
    );
  }
}
