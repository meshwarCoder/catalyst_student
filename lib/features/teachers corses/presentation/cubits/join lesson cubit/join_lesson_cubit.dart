import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinLessonCubit extends Cubit<JoinLessonState> {
  JoinLessonCubit(this.coursesRepoImpl) : super(JoinLessonInitial());
  final CoursesRepoImpl coursesRepoImpl;

  void joinLesson(int id) async {
    emit(JoinLessonLoading());
    final result = await coursesRepoImpl.joinRequest(id);
    result.fold(
      (failure) => emit(JoinLessonError(message: failure.errMessage)),
      (message) => emit(JoinLessonSuccess(message: message)),
    );
  }
}
