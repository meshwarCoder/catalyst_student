import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../entities/exam_result_entity.dart';

abstract class ExamResultRepo {
  Future<Either<Failure, ExamResultEntity>> getExamResult(int examId);
}
