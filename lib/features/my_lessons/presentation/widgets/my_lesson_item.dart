import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyLessonItem extends StatelessWidget {
  const MyLessonItem({super.key, required this.lesson});

  final MyLessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.color3, // DCDEE1
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
            // Header Row (Icon + Title + Avatar)
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueAccent.withOpacity(0.15),
                  child: const Icon(Icons.menu_book, color: Colors.blueAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: lesson.subject,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: "Teacher: ${lesson.teacher.name}",
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 6),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 6),

            // Schedule List
            if (lesson.lessonSchedules.isNotEmpty)
              ...lesson.lessonSchedules.map((schedule) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: CustomText(
                    text:
                        "${schedule.day}, ${schedule.startTime} (${schedule.duration} mins)",
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              })
            else
              CustomText(
                text: "No schedule available",
                color: Colors.black,
                fontSize: 12,
              ),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'View',
                onPressed: () {
                  GoRouter.of(
                    context,
                  ).push(Routs.studentLessonDetails, extra: lesson);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
