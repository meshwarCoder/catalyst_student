import 'package:equatable/equatable.dart';
import 'student_answer_entity.dart';

class StudentSubmissionEntity extends Equatable {
  final String? studentName;
  final num? totalGrade;
  final List<StudentAnswerEntity> answers;

  const StudentSubmissionEntity({
    this.studentName,
    this.totalGrade,
    required this.answers,
  });

  @override
  List<Object?> get props => [studentName, totalGrade, answers];
}
