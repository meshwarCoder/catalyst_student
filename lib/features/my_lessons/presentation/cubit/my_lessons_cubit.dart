import 'package:bloc/bloc.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:catalyst/features/my_lessons/data/repo/my_lessons_repo.dart';
import 'package:meta/meta.dart';

part 'my_lessons_state.dart';

class MyLessonsCubit extends Cubit<MyLessonsState> {
  final MyLessonsRepo myLessonsRepo;

  MyLessonsCubit(this.myLessonsRepo) : super(MyLessonsInitial());

  Future<void> getMyLessons() async {
    emit(MyLessonsLoading());
    final result = await myLessonsRepo.getMyLessons();
    result.fold(
      (failure) => emit(MyLessonsError(failure.errMessage)),
      (lessons) => emit(MyLessonsSuccess(lessons)),
    );
  }
}
