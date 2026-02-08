import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_model.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExamItem extends StatelessWidget {
  final ExamModel exam;
  const ExamItem({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    // Parse dates
    DateTime dateTime = DateTime.parse(exam.examDateTime);
    String formattedDate = DateFormat(
      'MMM dd, yyyy - hh:mm a',
    ).format(dateTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push(Routs.examQuestions, extra: exam.id);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.color3,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.orangeAccent.withOpacity(0.15),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: exam.examName,
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        const SizedBox(height: 2),
                        CustomText(
                          text: "Type: ${exam.examType}",
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomText(
                      text: "${exam.maxGrade} pts",
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.black26, thickness: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: formattedDate,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "${exam.durationMinutes} minutes",
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
