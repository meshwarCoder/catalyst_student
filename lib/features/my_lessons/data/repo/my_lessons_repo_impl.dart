import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:catalyst/features/my_lessons/data/repo/my_lessons_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MyLessonsRepoImpl implements MyLessonsRepo {
  final DioService dioService;

  MyLessonsRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, List<MyLessonModel>>> getMyLessons() async {
    try {
      final response = await dioService.get(path: EndPoint.myLessons);

      if (response.data is List) {
        final List<MyLessonModel> lessons = (response.data as List)
            .map((e) => MyLessonModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(lessons);
      } else if (response.data is Map<String, dynamic>) {
        // Handle wrapped response case (e.g. { "data": [...] })
        final data = response.data['data'];
        if (data is List) {
          final List<MyLessonModel> lessons = data
              .map((e) => MyLessonModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(lessons);
        }
        return Left(
          ServerFailure('Invalid data format: data field is not a list'),
        );
      } else {
        return Left(ServerFailure('Invalid data format'));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
