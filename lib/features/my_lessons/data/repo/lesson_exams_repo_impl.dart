import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_model.dart';
import 'package:catalyst/features/my_lessons/data/repo/lesson_exams_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonExamsRepoImpl implements LessonExamsRepo {
  final DioService dioService;

  LessonExamsRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, List<ExamModel>>> getLessonExams(int lessonId) async {
    try {
      final response = await dioService.get(
        path: EndPoint.lessonExams.replaceFirst(
          '{lessonId}',
          lessonId.toString(),
        ),
      );

      if (response.data is List) {
        final List<ExamModel> exams = (response.data as List)
            .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(exams);
      } else if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is List) {
          final List<ExamModel> exams = data
              .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(exams);
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
