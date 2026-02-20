import 'package:catalyst/core/enums/question_type.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_answer_entity.dart';
import 'package:flutter/material.dart';

import 'mcq_answer_widget.dart';
import 'writing_answer_widget.dart';
import 'true_false_answer_widget.dart';

class QuestionResultCard extends StatelessWidget {
  final StudentAnswerEntity answer;
  final int index;

  const QuestionResultCard({
    super.key,
    required this.answer,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final question = answer.question;
    final isCorrect = answer.mark == question.maxPoints;
    final isZero = answer.mark == 0;

    final Color backgroundColor = isCorrect
        ? Colors.green.withOpacity(0.05)
        : (isZero
              ? Colors.red.withOpacity(0.05)
              : Colors.orange.withOpacity(0.05));

    final Color borderColor = isCorrect
        ? Colors.green.withOpacity(0.1)
        : (isZero
              ? Colors.red.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(question.maxPoints, answer.mark),
          const SizedBox(height: 12),
          CustomText(
            text: '${index + 1}. ${question.text}',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.4,
          ),
          const SizedBox(height: 20),
          _buildAnswerBody(question.type, isCorrect),
        ],
      ),
    );
  }

  Widget _buildHeader(num maxPoints, num mark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomText(
            text: 'Question ${index + 1}',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        CustomText(
          text: '$mark / $maxPoints Pts',
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Colors.black54,
        ),
      ],
    );
  }

  Widget _buildAnswerBody(QuestionType type, bool isCorrect) {
    switch (type) {
      case QuestionType.MCQ:
        return McqAnswerWidget(
          options: answer.question.options,
          selectedOptions: answer.selectedOptions,
          isCorrect: isCorrect,
        );
      case QuestionType.WRITING:
        return WritingAnswerWidget(
          textAnswer: answer.textAnswer,
          mark: answer.mark,
          maxPoints: answer.question.maxPoints,
        );
      case QuestionType.TRUE_FALSE:
        return TrueFalseAnswerWidget(
          selectedOptions: answer.selectedOptions,
          isCorrect: isCorrect,
        );
    }
  }
}
