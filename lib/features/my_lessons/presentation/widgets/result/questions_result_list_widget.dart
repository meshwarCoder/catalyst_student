import 'package:catalyst/features/my_lessons/domain/entities/student_answer_entity.dart';
import 'package:flutter/material.dart';
import 'question_result_card.dart';

class QuestionsResultListWidget extends StatelessWidget {
  final List<StudentAnswerEntity> answers;

  const QuestionsResultListWidget({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return QuestionResultCard(answer: answers[index], index: index);
      },
    );
  }
}
