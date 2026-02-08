import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_details_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ExamQuestionsRepo {
  Future<Either<Failure, ExamDetailsModel>> getExamQuestions(int examId);
  Future<Either<Failure, Unit>> submitExam(
    int examId,
    List<Map<String, dynamic>> answers,
  );
}

class ExamQuestionsRepoImpl implements ExamQuestionsRepo {
  final DioService dioService;

  ExamQuestionsRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, ExamDetailsModel>> getExamQuestions(int examId) async {
    try {
      final response = await dioService.get(
        path: EndPoint.examQuestions.replaceFirst(
          '{examId}',
          examId.toString(),
        ),
      );

      // Some endpoints wrap the response in a 'data' field
      var data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        data = data['data'];
      }

      if (data is Map<String, dynamic>) {
        return Right(ExamDetailsModel.fromJson(data));
      } else {
        return Left(
          ServerFailure('Invalid data format: Expected exam details object'),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitExam(
    int examId,
    List<Map<String, dynamic>> answers,
  ) async {
    try {
      await dioService.post(
        path: EndPoint.submitExam.replaceFirst('{examId}', examId.toString()),
        data: answers,
      );
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
