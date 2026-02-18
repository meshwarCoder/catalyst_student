import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/custom_snackbar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_details_model.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_questions_cubit.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamQuestionsView extends StatefulWidget {
  final int examId;
  const ExamQuestionsView({super.key, required this.examId});

  @override
  State<ExamQuestionsView> createState() => _ExamQuestionsViewState();
}

class _ExamQuestionsViewState extends State<ExamQuestionsView> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ExamQuestionsCubit>()..getExamQuestions(widget.examId),
      child: BlocListener<ExamQuestionsCubit, ExamQuestionsState>(
        listener: (context, state) {
          if (state is ExamSubmissionSuccess) {
            CustomSnackBar.show(
              context,
              message: "Exam submitted successfully!",
            );
            Navigator.pop(context);
          } else if (state is ExamSubmissionError) {
            CustomSnackBar.show(
              context,
              message: state.errMessage,
              isError: true,
            );
          }
        },
        child: BlocBuilder<ExamQuestionsCubit, ExamQuestionsState>(
          builder: (context, state) {
            return BaseScaffold(
              title: "Examination",
              child: BlocBuilder<ExamQuestionsCubit, ExamQuestionsState>(
                buildWhen: (previous, current) =>
                    current is! ExamSubmissionLoading &&
                    current is! ExamSubmissionSuccess &&
                    current is! ExamSubmissionError,
                builder: (context, state) {
                  if (state is ExamQuestionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExamQuestionsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CustomText(
                          text: state.errMessage,
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  } else if (state is ExamQuestionsSuccess) {
                    final exam = state.examDetails;
                    return Column(
                      children: [
                        _buildTimerHeader(state.remainingSeconds),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: exam.questions.length,
                            itemBuilder: (context, index) {
                              return _buildQuestionCard(
                                context,
                                exam.questions[index],
                                state.answers[exam.questions[index].id],
                                index + 1,
                                state.remainingSeconds <= 0,
                              );
                            },
                          ),
                        ),
                        _buildSubmissionButton(context, state),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerHeader(int seconds) {
    bool isLowTime = seconds < 60;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLowTime ? AppColors.color2 : AppColors.color1,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isLowTime ? AppColors.color2 : AppColors.color1)
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomText(
            text: "Time Remaining",
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: _formatTime(seconds),
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionButton(
    BuildContext context,
    ExamQuestionsSuccess state,
  ) {
    return BlocBuilder<ExamQuestionsCubit, ExamQuestionsState>(
      builder: (context, submissionState) {
        bool isSubmitting = submissionState is ExamSubmissionLoading;
        bool isError = submissionState is ExamSubmissionError;
        bool isTimedOut = state.remainingSeconds <= 0;

        String text = "Submit Final Answers";
        if (isSubmitting)
          text = "Recording...";
        else if (isError)
          text = "Retry Submission";
        else if (isTimedOut)
          text = "Exam Ended";

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            text: text,
            onPressed: isSubmitting || (isTimedOut && !isError)
                ? null
                : () {
                    context.read<ExamQuestionsCubit>().submitCurrentAnswers(
                      widget.examId,
                    );
                  },
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return "00:00";
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildQuestionCard(
    BuildContext context,
    QuestionModel question,
    dynamic currentAnswer,
    int number,
    bool isDisabled,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuestionLabel(number),
                Row(
                  children: [
                    _buildMetaBadge(question.type, Colors.blue),
                    const SizedBox(width: 8),
                    _buildMetaBadge("${question.maxPoints} pts", Colors.orange),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomText(
              text: question.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            const SizedBox(height: 24),
            _buildAnswerInput(context, question, currentAnswer, isDisabled),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionLabel(int number) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.color2,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        CustomText(
          text: "Question $number",
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.text,
        ),
      ],
    );
  }

  Widget _buildMetaBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text: text,
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAnswerInput(
    BuildContext context,
    QuestionModel question,
    dynamic currentAnswer,
    bool isDisabled,
  ) {
    if (question.type == 'MCQ' || question.type == 'TRUE_FALSE') {
      return Column(
        children: List.generate(question.options.length, (index) {
          final option = question.options[index];
          final isSelected = currentAnswer == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: isDisabled
                  ? null
                  : () {
                      context.read<ExamQuestionsCubit>().updateAnswer(
                        question.id,
                        index,
                      );
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.color1 : Colors.black12,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? AppColors.color1.withOpacity(0.05)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.color1 : Colors.black26,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColors.color1
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomText(
                        text: option,
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else if (question.type == 'TEXT' || question.type == 'WRITING') {
      final controller = _controllers.putIfAbsent(
        question.id,
        () => TextEditingController(text: currentAnswer?.toString() ?? ""),
      );

      return TextField(
        enabled: !isDisabled,
        onChanged: (value) {
          context.read<ExamQuestionsCubit>().updateAnswer(question.id, value);
        },
        controller: controller,
        style: GoogleFonts.comfortaa(fontSize: 14, color: AppColors.text),
        decoration: InputDecoration(
          hintText: "Type your detailed answer here...",
          hintStyle: GoogleFonts.comfortaa(color: Colors.black26),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.color1, width: 2),
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
        maxLines: 4,
      );
    }
    return const SizedBox();
  }
}
