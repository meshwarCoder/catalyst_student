import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../entities/exam_result_entity.dart';
import '../repo/exam_result_repo.dart';

class GetExamResultUseCase {
  final ExamResultRepo repository;

  GetExamResultUseCase(this.repository);

  Future<Either<Failure, ExamResultEntity>> call(int examId) async {
    return await repository.getExamResult(examId);
  }
}
