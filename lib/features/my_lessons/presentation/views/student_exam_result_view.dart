import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/my_lessons/domain/entities/exam_result_entity.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_result_cubit.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/result/questions_result_list_widget.dart';
import '../widgets/result/result_header_widget.dart';
import '../widgets/result/result_summary_widget.dart';

class StudentExamResultScreen extends StatefulWidget {
  final int examId;

  const StudentExamResultScreen({super.key, required this.examId});

  @override
  State<StudentExamResultScreen> createState() =>
      _StudentExamResultScreenState();
}

class _StudentExamResultScreenState extends State<StudentExamResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExamResultCubit>().getExamResult(widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Exam Result',
      child: BlocBuilder<ExamResultCubit, ExamResultState>(
        builder: (context, state) {
          if (state is ExamResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamResultLoaded) {
            return _buildContent(state.examResult);
          } else if (state is ExamResultError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(ExamResultEntity result) {
    final submission = result.mySubmission;
    final num score = submission?.totalGrade ?? 0;
    final num maxScore = result.maxGrade;
    final double percentage = maxScore > 0 ? score / maxScore : 0.0;

    // Choose color based on percentage
    final Color themeColor = percentage >= 0.8
        ? Colors.green
        : (percentage >= 0.5 ? Colors.orange : Colors.red);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ResultHeaderWidget(
              studentName: submission?.studentName ?? 'Student',
              examName: result.examName,
              statusText: result.status.name.toUpperCase(),
              statusColor: themeColor,
              date: result.examDateTime,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ResultSummaryWidget(
              score: score,
              maxScore: maxScore,
              percentage: percentage,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 10),
          if (submission != null)
            QuestionsResultListWidget(answers: submission.answers),
        ],
      ),
    );
  }
}
