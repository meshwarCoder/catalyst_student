import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_details_model.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_questions_cubit.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamQuestionsView extends StatefulWidget {
  final int examId;
  const ExamQuestionsView({super.key, required this.examId});

  @override
  State<ExamQuestionsView> createState() => _ExamQuestionsViewState();
}

class _ExamQuestionsViewState extends State<ExamQuestionsView> {
  // Store answers: {questionId: index (int) or text (String)}
  final Map<int, dynamic> _answers = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ExamQuestionsCubit>()..getExamQuestions(widget.examId),
      child: BlocListener<ExamQuestionsCubit, ExamQuestionsState>(
        listener: (context, state) {
          if (state is ExamSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Exam submitted successfully!")),
            );
            Navigator.pop(context);
          } else if (state is ExamSubmissionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        child: BaseScaffold(
          title: "Exam Questions",
          child: BlocBuilder<ExamQuestionsCubit, ExamQuestionsState>(
            buildWhen: (previous, current) =>
                current is! ExamSubmissionLoading &&
                current is! ExamSubmissionSuccess &&
                current is! ExamSubmissionError,
            builder: (context, state) {
              if (state is ExamQuestionsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExamQuestionsError) {
                return Center(child: Text(state.errMessage));
              } else if (state is ExamQuestionsSuccess) {
                final exam = state.examDetails;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: exam.questions.length,
                        itemBuilder: (context, index) {
                          return _buildQuestionCard(exam.questions[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          BlocBuilder<ExamQuestionsCubit, ExamQuestionsState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: state is ExamSubmissionLoading
                                    ? "Submitting..."
                                    : "Submit Exam",
                                onPressed: state is ExamSubmissionLoading
                                    ? null
                                    : () {
                                        final submissionData =
                                            _prepareSubmission(exam.questions);
                                        context
                                            .read<ExamQuestionsCubit>()
                                            .submitExam(
                                              widget.examId,
                                              submissionData,
                                            );
                                      },
                              );
                            },
                          ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareSubmission(List<QuestionModel> questions) {
    return questions.map((q) {
      final answer = _answers[q.id];
      if (q.type == 'MCQ' || q.type == 'TRUE_FALSE') {
        return {
          "questionId": q.id,
          "selectedOptions": answer != null ? [answer] : [],
          "textAnswer": null,
        };
      } else {
        return {
          "questionId": q.id,
          "selectedOptions": [],
          "textAnswer": answer,
        };
      }
    }).toList();
  }

  Widget _buildQuestionCard(QuestionModel question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.type,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${question.maxPoints} pts",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAnswerInput(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput(QuestionModel question) {
    if (question.type == 'MCQ' || question.type == 'TRUE_FALSE') {
      return Column(
        children: List.generate(question.options.length, (index) {
          final option = question.options[index];
          return RadioListTile<int>(
            title: Text(option),
            value: index,
            groupValue: _answers[question.id],
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
          );
        }),
      );
    } else if (question.type == 'TEXT' || question.type == 'WRITING') {
      return TextField(
        onChanged: (value) {
          _answers[question.id] = value;
        },
        decoration: const InputDecoration(
          hintText: "Enter your answer here...",
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      );
    }
    return const SizedBox();
  }
}
