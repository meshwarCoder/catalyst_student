import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_state.dart';
import 'package:catalyst/features/teachers%20corses/presentation/widgets/teacher_course_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCoursesView extends StatefulWidget {
  const TeacherCoursesView({super.key});

  @override
  State<TeacherCoursesView> createState() => _TeacherCoursesViewState();
}

class _TeacherCoursesViewState extends State<TeacherCoursesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllCoursesCubit>().getAllCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllCoursesCubit, GetAllCoursesState>(
      listener: (context, state) {
        if (state is GetAllCoursesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.message, color: Colors.white),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetAllCoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetAllCoursesSuccess) {
          final courses = state.courses;

          if (courses.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No courses available",
                color: Colors.black,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final item = courses[index];
                return TeacherCourseItem(course: item);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
