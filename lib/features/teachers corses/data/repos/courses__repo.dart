import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/teachers%20corses/data/models/get_all_courses_model.dart';
import 'package:dartz/dartz.dart';

abstract class CoursesRepo {
  Future<Either<Failure, List<Lesson>>> getAllCourses();
  Future<Either<Failure, String>> joinRequest(int id);
}
