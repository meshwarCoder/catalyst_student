class EndPoint {
  static final String baseUrl =
      'https://vehemently-encastra-christena.ngrok-free.dev/';
  //==========auth=============
  static final String signUp = 'api/auth/student/signup';
  static final String login = 'api/auth/student/login';
  static final String forgotPassword = 'api/student/forgot-password';
  static final String verifyCode = 'api/student/verify-reset-code';
  static final String resetPassword = 'api/student/reset-password';
  static final String allLessons = 'api/student/lesson/all';
  static final String joinLesson = '/class-requests/join';
}

class ApiKey {
  static String fullName = 'fullName';
  static String email = 'email';
  static String password = 'password';
}

class Body {
  static String fullName = 'fullName';
  static String email = 'email';
  static String password = 'password';
  static String phone = 'phoneNumber';
  static String birthYear = 'birthYear';
  static String currentAcademicYear = 'currentAcademicYear';
  static String bio = 'bio';
  static String code = 'code';
  static String newPassword = 'newPassword';
  static String resetToken = 'resetToken';
}
