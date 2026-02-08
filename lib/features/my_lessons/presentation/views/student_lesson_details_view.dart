import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/lesson_exams_cubit.dart';
import 'package:catalyst/features/my_lessons/presentation/widgets/exam_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLessonDetailsView extends StatelessWidget {
  final MyLessonModel lesson;
  const StudentLessonDetailsView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LessonExamsCubit>()..getLessonExams(lesson.id),
      child: BaseScaffold(
        title: lesson.subject,
        child: BlocBuilder<LessonExamsCubit, LessonExamsState>(
          builder: (context, state) {
            if (state is LessonExamsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LessonExamsError) {
              return Center(child: Text(state.errMessage));
            } else if (state is LessonExamsSuccess) {
              if (state.exams.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.assignment_late_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "No Exams Found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "There are no exams scheduled for this class yet. Good luck with your studies!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.exams.length,
                itemBuilder: (context, index) {
                  return ExamItem(exam: state.exams[index]);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
