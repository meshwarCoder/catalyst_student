import 'package:equatable/equatable.dart';
import '../../../../core/enums/exam_type.dart';
import '../../../../core/enums/student_exam_status.dart';
import 'question_entity.dart';
import 'student_submission_entity.dart';

class ExamResultEntity extends Equatable {
  final int id;
  final int? lessonId;
  final String examName;
  final num maxGrade;
  final String? examDateTime;
  final String? closingDate;
  final int? durationMinutes;
  final ExamType? examType;
  final List<QuestionEntity> questions;
  final StudentExamStatus status;
  final StudentSubmissionEntity? mySubmission;

  const ExamResultEntity({
    required this.id,
    this.lessonId,
    required this.examName,
    required this.maxGrade,
    this.examDateTime,
    this.closingDate,
    this.durationMinutes,
    this.examType,
    required this.questions,
    required this.status,
    this.mySubmission,
  });

  @override
  List<Object?> get props => [
    id,
    lessonId,
    examName,
    maxGrade,
    examDateTime,
    closingDate,
    durationMinutes,
    examType,
    questions,
    status,
    mySubmission,
  ];
}
