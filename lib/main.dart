import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_cubit.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_cubit.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/databases/cache_helper.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  setupServiceLocator();
  runApp(const CatalystStudent());
}

class CatalystStudent extends StatelessWidget {
  const CatalystStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoinLessonCubit(getIt.get<CoursesRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              ForgetPasswordCubit(getIt.get<AuthRepoImplementation>()),
        ),
        BlocProvider(
          create: (context) => GetAllCoursesCubit(getIt.get<CoursesRepoImpl>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: Routs.router,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
