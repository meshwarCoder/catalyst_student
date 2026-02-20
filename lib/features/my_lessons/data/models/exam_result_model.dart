import '../../../../core/enums/exam_type.dart';
import '../../../../core/enums/student_exam_status.dart';
import '../../domain/entities/exam_result_entity.dart';
import 'question_model.dart';
import 'student_submission_model.dart';

class ExamResultModel extends ExamResultEntity {
  const ExamResultModel({
    required super.id,
    super.lessonId,
    required super.examName,
    required super.maxGrade,
    super.examDateTime,
    super.closingDate,
    super.durationMinutes,
    super.examType,
    required super.questions,
    required super.status,
    super.mySubmission,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id'] as int? ?? 0,
      lessonId: json['lessonId'] as int?,
      examName: json['examName'] as String? ?? '',
      maxGrade: json['maxGrade'] as num? ?? 0,
      examDateTime: json['examDateTime'] as String?,
      closingDate: json['closingDate'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      examType: json['examType'] != null
          ? _parseExamType(json['examType'] as String)
          : null,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: StudentExamStatusX.fromString(
        json['status'] as String? ?? 'UPCOMING',
      ),
      mySubmission: json['mySubmission'] != null
          ? StudentSubmissionModel.fromJson(
              json['mySubmission'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static ExamType _parseExamType(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return ExamType.MCQ;
      case 'WRITING':
        return ExamType.WRITING;
      case 'TRUE_FALSE':
        return ExamType.TRUE_FALSE;
      case 'MIXED':
        return ExamType.MIXED;
      default:
        return ExamType.MIXED;
    }
  }
}
