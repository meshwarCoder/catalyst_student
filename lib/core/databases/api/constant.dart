class EndPoint {
  static final String baseUrl =
      'https://vehemently-encastra-christena.ngrok-free.dev/';
  //==========auth=============
  static final String signUp = 'api/auth/student/signup';
  static final String login = 'api/auth/student/login';
  static final String forgotPassword = 'api/auth/student/forgot-password';
  static final String resendVerification =
      'api/auth/student/resend-verification';

  static final String refreshToken = 'api/auth/student/refresh';

  static final String allLessons = 'api/student/lesson/all';
  static final String joinLesson = 'api/student/lesson/{lessonId}/join-request';
  static final String myLessons = 'api/student/lesson/my';
  static final String lessonExams = 'api/student/lesson/{lessonId}/exams';
  static final String examQuestions = 'api/student/exam/{examId}';
  static final String submitExam = 'api/student/exam/{examId}/submit';
}

class ApiKey {
  static String fullName = 'fullName';
  static String email = 'email';
  static String password = 'password';
}

class BodyRequest {
  static final String fullName = 'fullName';
  static final String userName = 'username';
  static final String email = 'email';
  static final String password = 'password';
  static final String deviceData = 'deviceData';
  static final String fcmToken = "fcmToken";
  static final String deviceId = "deviceId";
  static final String deviceType = "deviceType";
}
