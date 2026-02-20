import 'package:catalyst/core/enums/student_exam_status.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_exam_entity.dart';

class ExamModel extends StudentExamEntity {
  ExamModel({
    required super.id,
    required super.examName,
    required super.maxGrade,
    required super.examDateTime,
    required super.closingDate,
    required super.durationMinutes,
    required super.completed,
    required super.status,
    super.studentGrade,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as int? ?? 0,
      examName: json['examName'] as String? ?? '',
      maxGrade: json['maxGrade'] as num? ?? 0,
      examDateTime: json['examDateTime'] as String? ?? '',
      closingDate: json['closingDate'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      status: StudentExamStatusX.fromString(json['status'] as String? ?? ''),
      studentGrade: json['studentGrade'] as num?,
    );
  }
}
