import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_exam_entity.dart';
import 'package:dartz/dartz.dart';

abstract class LessonExamsRepo {
  Future<Either<Failure, List<StudentExamEntity>>> getLessonExams(int lessonId);
}
