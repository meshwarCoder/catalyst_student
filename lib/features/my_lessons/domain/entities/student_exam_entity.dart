import 'package:catalyst/core/enums/student_exam_status.dart';

class StudentExamEntity {
  final int id;
  final String examName;
  final num maxGrade;
  final String examDateTime;
  final String? closingDate;
  final int durationMinutes;
  final bool completed;
  final StudentExamStatus status;
  final num? studentGrade;

  StudentExamEntity({
    required this.id,
    required this.examName,
    required this.maxGrade,
    required this.examDateTime,
    required this.closingDate,
    required this.durationMinutes,
    required this.completed,
    required this.status,
    this.studentGrade,
  });

  factory StudentExamEntity.fromJson(Map<String, dynamic> json) {
    return StudentExamEntity(
      id: json['id'] as int,
      examName: json['examName'] as String,
      maxGrade: json['maxGrade'] as num,
      examDateTime: json['examDateTime'] as String,
      closingDate: json['closingDate'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      status: StudentExamStatusX.fromString(json['status'] as String? ?? ''),
      studentGrade: json['studentGrade'] as num?,
    );
  }
}
