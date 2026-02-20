import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/email%20verification%20cubit/email_verification_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/login%20cubit/login_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/register%20cubit/register_cubit.dart';
import 'package:catalyst/features/auth/presentation/views/email_verification_view.dart';
import 'package:catalyst/features/auth/presentation/views/forget_password_view.dart';
import 'package:catalyst/features/auth/presentation/views/login_view.dart';
import 'package:catalyst/features/auth/presentation/views/register_view.dart';
import 'package:catalyst/features/auth/presentation/views/send_email_view.dart';
import 'package:catalyst/features/home/presentation/views/home_view.dart';
import 'package:catalyst/features/roots.dart';
import 'package:catalyst/features/splash/splash_view.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/views/teatcher_corses.dart';
import 'package:catalyst/features/my_lessons/presentation/views/student_lesson_details_view.dart';
import 'package:catalyst/features/my_lessons/data/models/my_lesson_model.dart';
import 'package:catalyst/features/my_lessons/presentation/views/exam_questions_view.dart';
import 'package:catalyst/features/my_lessons/presentation/views/student_exam_result_view.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_result_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Routs {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/emailVerification';
  static const String forgetPassword = '/forgetPassword';
  static const String sendEmail = '/sendEmail';
  static const String root = '/root';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String students = '/students';
  static const String autoGrade = '/autoGrade';
  static const String teachersCourses = '/teachersCourses';
  static const String teacherCourses = '/teacherCourses';
  static const String studentLessonDetails = '/studentLessonDetails';
  static const String examQuestions = '/examQuestions';
  static const String examResult = '/examResult';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashView()),
      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(getIt.get<AuthRepoImplementation>()),
          child: LoginView(),
        ),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              RegisterCubit(getIt.get<AuthRepoImplementation>()),
          child: RegisterView(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(getIt.get<AuthRepoImplementation>()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: forgetPassword,
            builder: (context, state) => ForgetPassword(),
          ),

          GoRoute(
            path: sendEmail,
            builder: (context, state) => SendEmailView(),
          ),
        ],
      ),
      GoRoute(
        path: emailVerification,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              EmailVerificationCubit(getIt.get<AuthRepoImplementation>()),
          child: EmailVerificationView(email: state.extra as String),
        ),
      ),
      GoRoute(path: root, builder: (context, state) => const Root()),
      GoRoute(path: home, builder: (context, state) => const HomeView()),

      GoRoute(
        path: teacherCourses,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<GetAllCoursesCubit>(),
          child: const TeacherCoursesView(),
        ),
      ),
      GoRoute(
        path: studentLessonDetails,
        builder: (context, state) =>
            StudentLessonDetailsView(lesson: state.extra as MyLessonModel),
      ),
      GoRoute(
        path: examQuestions,
        builder: (context, state) =>
            ExamQuestionsView(examId: state.extra as int),
      ),
      GoRoute(
        path: examResult,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ExamResultCubit>(),
          child: StudentExamResultScreen(examId: state.extra as int),
        ),
      ),
    ],
  );
}
