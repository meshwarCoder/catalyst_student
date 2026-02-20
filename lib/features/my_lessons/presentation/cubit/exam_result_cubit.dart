import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_exam_result_use_case.dart';
import 'exam_result_state.dart';

class ExamResultCubit extends Cubit<ExamResultState> {
  final GetExamResultUseCase getExamResultUseCase;

  ExamResultCubit({required this.getExamResultUseCase})
    : super(ExamResultInitial());

  Future<void> getExamResult(int examId) async {
    emit(ExamResultLoading());
    final result = await getExamResultUseCase.call(examId);
    result.fold(
      (failure) => emit(ExamResultError(failure.errMessage)),
      (examResult) => emit(ExamResultLoaded(examResult)),
    );
  }
}
