abstract class JoinLessonState {}

final class JoinLessonInitial extends JoinLessonState {}

final class JoinLessonLoading extends JoinLessonState {}

final class JoinLessonSuccess extends JoinLessonState {
  final String message;

  JoinLessonSuccess({required this.message});
}

final class JoinLessonError extends JoinLessonState {
  final String message;

  JoinLessonError({required this.message});
}
