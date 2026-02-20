import 'package:bloc/bloc.dart';
import 'package:catalyst/features/my_lessons/data/repo/lesson_exams_repo.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_exam_entity.dart';
import 'package:meta/meta.dart';

part 'lesson_exams_state.dart';

class LessonExamsCubit extends Cubit<LessonExamsState> {
  final LessonExamsRepo lessonExamsRepo;

  LessonExamsCubit(this.lessonExamsRepo) : super(LessonExamsInitial());

  Future<void> getLessonExams(int lessonId) async {
    emit(LessonExamsLoading());
    final result = await lessonExamsRepo.getLessonExams(lessonId);
    result.fold(
      (failure) => emit(LessonExamsError(failure.errMessage)),
      (exams) => emit(LessonExamsSuccess(exams)),
    );
  }
}
