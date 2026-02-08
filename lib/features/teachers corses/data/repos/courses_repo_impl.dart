import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/teachers%20corses/data/models/get_all_courses_model.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses__repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CoursesRepoImpl implements CoursesRepo {
  final DioService dioService;
  CoursesRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, List<Lesson>>> getAllCourses() async {
    try {
      final response = await dioService.get(path: EndPoint.allLessons);

      List<Lesson> lessons = [];

      for (var lesson in response.data['data']) {
        lessons.add(Lesson.fromJson(lesson));
      }
      return Right(lessons);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, String>> joinRequest(int id) async {
    try {
      final response = await dioService.post(
        path: EndPoint.joinLesson.replaceAll('{lessonId}', id.toString()),
      );

      final message =
          response.data['message'] ?? 'Join request sent successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    }
  }
}
