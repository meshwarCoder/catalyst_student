import 'package:equatable/equatable.dart';
import '../../../../core/enums/question_type.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final num maxPoints;

  const QuestionEntity({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.maxPoints,
  });

  @override
  List<Object?> get props => [id, text, type, options, maxPoints];
}
