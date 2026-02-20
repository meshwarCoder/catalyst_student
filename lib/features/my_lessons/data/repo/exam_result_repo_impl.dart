import 'package:dartz/dartz.dart';
import '../../../../core/databases/api/dio_service.dart';
import '../../../../core/databases/api/constant.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/exam_result_entity.dart';
import '../../domain/repo/exam_result_repo.dart';
import '../models/exam_result_model.dart';
import 'package:dio/dio.dart';

class ExamResultRepoImpl implements ExamResultRepo {
  final DioService dioService;

  ExamResultRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, ExamResultEntity>> getExamResult(int examId) async {
    try {
      final response = await dioService.get(
        path: EndPoint.examQuestions.replaceFirst(
          '{examId}',
          examId.toString(),
        ),
      );

      // Handle response structure based on what DioService returns (it returns a Response object)
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return Right(ExamResultModel.fromJson(data));
        }
        return Left(
          ServerFailure(
            'Invalid data format: data field is missing or not a map',
          ),
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
