import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WritingAnswerWidget extends StatelessWidget {
  final String? textAnswer;
  final num mark;
  final num maxPoints;

  const WritingAnswerWidget({
    super.key,
    required this.textAnswer,
    required this.mark,
    required this.maxPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Student Answer:',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: CustomText(
            text: textAnswer ?? 'No answer provided.',
            fontSize: 15,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildScoreBadge(),
      ],
    );
  }

  Widget _buildScoreBadge() {
    final isFullMark = mark == maxPoints;
    final isZero = mark == 0;
    final Color color = isFullMark
        ? Colors.green
        : (isZero ? Colors.red : Colors.orange);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        text: 'Score: $mark / $maxPoints',
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
