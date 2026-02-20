import 'package:catalyst/features/teachers%20corses/data/models/get_all_courses_model.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCourseItem extends StatelessWidget {
  const TeacherCourseItem({super.key, required this.course});

  final Lesson course;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinLessonCubit, JoinLessonState>(
      listener: (context, state) {
        if (state is JoinLessonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.message, color: Colors.white),
            ),
          );
        }
        if (state is JoinLessonSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.message, color: Colors.white),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.color3, // لون DCDEE1
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
                // Header Row (Icon + Title + Students + Avatar)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blueAccent.withOpacity(0.15),
                      child: const Icon(
                        Icons.menu_book,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: course.subject,
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            text: "${course.studentsCount} Students",
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            text: "Teacher: ${course.teacher.fullName}",
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
                CustomText(
                  text: "sat,mon,wed, 10:00 - 12:00",
                  color: Colors.black,
                  fontSize: 12,
                ),

                const SizedBox(height: 18),
                CustomButton(
                  text: course.isJoined ? 'Already Joined' : 'Join Request',
                  backgroundColor: course.isJoined ? Colors.grey : null,
                  onPressed: course.isJoined
                      ? null
                      : () {
                          context.read<JoinLessonCubit>().joinLesson(course.id);
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
