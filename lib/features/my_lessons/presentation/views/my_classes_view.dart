import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/my_lessons_cubit.dart';
import 'package:catalyst/features/my_lessons/presentation/widgets/my_lesson_item.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClassesView extends StatelessWidget {
  const MyClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyLessonsCubit>()..getMyLessons(),
      child: Scaffold(
        backgroundColor: const Color(0xffEEEEEE),
        body: BlocBuilder<MyLessonsCubit, MyLessonsState>(
          builder: (context, state) {
            if (state is MyLessonsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyLessonsError) {
              return Center(child: Text(state.errMessage));
            } else if (state is MyLessonsSuccess) {
              if (state.lessons.isEmpty) {
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
                          child: Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomText(
                          text: "No Classes Joined Yet",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: CustomText(
                            text:
                                "You haven't enrolled in any classes. Join a course to track your lessons here.",
                            textAlign: TextAlign.center,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.lessons.length,
                itemBuilder: (context, index) {
                  return MyLessonItem(lesson: state.lessons[index]);
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
