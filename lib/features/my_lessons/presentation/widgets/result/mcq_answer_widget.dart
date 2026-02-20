import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class McqAnswerWidget extends StatelessWidget {
  final List<String> options;
  final List<int> selectedOptions;
  final bool isCorrect;

  const McqAnswerWidget({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = selectedOptions.contains(index);
        Color bgColor = Colors.transparent;
        Color textColor = Colors.grey[800]!;
        Color borderColor = Colors.grey[200]!;

        if (isSelected) {
          bgColor = isCorrect
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1);
          textColor = isCorrect ? Colors.green[700]! : Colors.red[700]!;
          borderColor = isCorrect ? Colors.green[300]! : Colors.red[300]!;
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? textColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? textColor : Colors.grey[400]!,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        isCorrect ? Icons.check : Icons.close,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomText(
                  text: options[index],
                  fontSize: 15,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
