import '../../domain/entities/student_submission_entity.dart';
import 'student_answer_model.dart';

class StudentSubmissionModel extends StudentSubmissionEntity {
  const StudentSubmissionModel({
    required super.studentName,
    super.totalGrade,
    required super.answers,
  });

  factory StudentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return StudentSubmissionModel(
      studentName: json['studentName'] as String?,
      totalGrade: json['totalGrade'] as num?,
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map(
                (e) => StudentAnswerModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
