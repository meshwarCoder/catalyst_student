import 'package:equatable/equatable.dart';
import '../../domain/entities/exam_result_entity.dart';

abstract class ExamResultState extends Equatable {
  const ExamResultState();

  @override
  List<Object?> get props => [];
}

class ExamResultInitial extends ExamResultState {}

class ExamResultLoading extends ExamResultState {}

class ExamResultLoaded extends ExamResultState {
  final ExamResultEntity examResult;

  const ExamResultLoaded(this.examResult);

  @override
  List<Object?> get props => [examResult];
}

class ExamResultError extends ExamResultState {
  final String message;

  const ExamResultError(this.message);

  @override
  List<Object?> get props => [message];
}
