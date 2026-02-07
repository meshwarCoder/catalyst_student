import 'package:catalyst/core/api/constant.dart';

class SignUpRequest {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final int birthYear;
  final String currentAcademicYear;
  final String bio;

  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.birthYear,
    required this.currentAcademicYear,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
    Body.fullName: fullName,
    Body.email: email,
    Body.password: password,
    Body.phone: phone,
    Body.birthYear: birthYear,
    Body.currentAcademicYear: currentAcademicYear,
    Body.bio: bio,
  };
}
