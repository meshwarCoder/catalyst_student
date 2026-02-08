import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:dartz/dartz.dart';

abstract class MyLessonsRepo {
  Future<Either<Failure, List<MyLessonModel>>> getMyLessons();
}
