import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TrueFalseAnswerWidget extends StatelessWidget {
  final List<int> selectedOptions; // 0 for True, 1 for False
  final bool isCorrect;

  const TrueFalseAnswerWidget({
    super.key,
    required this.selectedOptions,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = selectedOptions.isNotEmpty
        ? selectedOptions.first
        : -1;

    return Row(
      children: [
        Expanded(child: _buildOption(0, 'True', selectedIndex == 0)),
        const SizedBox(width: 16),
        Expanded(child: _buildOption(1, 'False', selectedIndex == 1)),
      ],
    );
  }

  Widget _buildOption(int index, String label, bool isSelected) {
    Color bgColor = Colors.grey[50]!;
    Color textColor = Colors.grey[600]!;
    Color borderColor = Colors.grey[200]!;

    if (isSelected) {
      bgColor = isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1);
      textColor = isCorrect ? Colors.green[700]! : Colors.red[700]!;
      borderColor = isCorrect ? Colors.green[300]! : Colors.red[300]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSelected) ...[
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          CustomText(
            text: label,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
