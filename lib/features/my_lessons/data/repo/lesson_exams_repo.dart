import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_model.dart';
import 'package:dartz/dartz.dart';

abstract class LessonExamsRepo {
  Future<Either<Failure, List<ExamModel>>> getLessonExams(int lessonId);
}
