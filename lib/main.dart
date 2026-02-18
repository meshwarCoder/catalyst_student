import 'dart:io';

import 'package:catalyst/core/databases/api/api_interceptors.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/services/notification_services.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/utils/time_service.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_cubit.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_cubit.dart';
import 'package:catalyst/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  setupServiceLocator();

  // Handle unauthorized events (e.g. refresh token reuse)
  ApiInterceptors.onUnAuthorized = () {
    print('DEBUG: Force logout triggered. Navigating to Login.');
    Routs.router.go(Routs.login);
  };

  await getIt<TimeService>().init();
  // init firebase
  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // init notification service
  if (!Platform.isLinux) {
    await NotificationService.init();
  }
  runApp(const CatalystStudent());
}

class CatalystStudent extends StatelessWidget {
  const CatalystStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LogoutCubit(getIt.get<AuthRepoImplementation>()),
        ),
        BlocProvider(
          create: (context) => JoinLessonCubit(getIt.get<CoursesRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              ForgetPasswordCubit(getIt.get<AuthRepoImplementation>()),
        ),
        BlocProvider(create: (context) => getIt<GetAllCoursesCubit>()),
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
