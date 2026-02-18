import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/auth/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:dio/dio.dart';
import 'package:catalyst/features/teachers%20corses/data/repos/courses_repo_impl.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/get%20all%20courses%20cubit/get_all_courses_cubit.dart';
import 'package:catalyst/features/teachers%20corses/presentation/cubits/join%20lesson%20cubit/join_lesson_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:catalyst/features/my_lessons/data/repo/my_lessons_repo_impl.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/my_lessons_cubit.dart';
import 'package:catalyst/features/my_lessons/data/repo/lesson_exams_repo_impl.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/lesson_exams_cubit.dart';
import 'package:catalyst/features/my_lessons/data/repo/exam_questions_repo.dart';
import 'package:catalyst/features/my_lessons/presentation/cubit/exam_questions_cubit.dart';
import 'package:catalyst/core/utils/time_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // ========== CORE ==========
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<TimeService>(() => TimeService());

  getIt.registerLazySingleton<DioService>(() => DioService(dio: getIt<Dio>()));

  // ========== AUTH ==========
  getIt.registerLazySingleton<RemoteDataSourceImplementation>(
    () => RemoteDataSourceImplementation(apiService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<AuthRepoImplementation>(
    () => AuthRepoImplementation(
      remoteDataSourceImplementation: getIt<RemoteDataSourceImplementation>(),
    ),
  );

  getIt.registerFactory<LogoutCubit>(
    () => LogoutCubit(getIt<AuthRepoImplementation>()),
  );

  // ========== TEACHERS COURSES ==========
  getIt.registerLazySingleton<CoursesRepoImpl>(
    () => CoursesRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerFactory<GetAllCoursesCubit>(
    () => GetAllCoursesCubit(
      getIt<CoursesRepoImpl>(),
      getIt<MyLessonsRepoImpl>(),
    ),
  );

  getIt.registerFactory<JoinLessonCubit>(
    () => JoinLessonCubit(getIt<CoursesRepoImpl>()),
  );

  // ========== MY LESSONS ==========
  getIt.registerLazySingleton<MyLessonsRepoImpl>(
    () => MyLessonsRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerFactory<MyLessonsCubit>(
    () => MyLessonsCubit(getIt<MyLessonsRepoImpl>()),
  );

  // ========== LESSON EXAMS ==========
  getIt.registerLazySingleton<LessonExamsRepoImpl>(
    () => LessonExamsRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerFactory<LessonExamsCubit>(
    () => LessonExamsCubit(getIt<LessonExamsRepoImpl>()),
  );

  // ========== EXAM QUESTIONS ==========
  getIt.registerLazySingleton<ExamQuestionsRepoImpl>(
    () => ExamQuestionsRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerFactory<ExamQuestionsCubit>(
    () => ExamQuestionsCubit(getIt<ExamQuestionsRepoImpl>()),
  );
}
