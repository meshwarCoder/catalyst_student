import 'package:equatable/equatable.dart';
import 'question_entity.dart';

class StudentAnswerEntity extends Equatable {
  final int id;
  final QuestionEntity question;
  final List<int> selectedOptions;
  final String? textAnswer;
  final num mark;

  const StudentAnswerEntity({
    required this.id,
    required this.question,
    required this.selectedOptions,
    this.textAnswer,
    required this.mark,
  });

  @override
  List<Object?> get props => [id, question, selectedOptions, textAnswer, mark];
}
