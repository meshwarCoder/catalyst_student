import '../../domain/entities/question_entity.dart';
import '../../../../core/enums/question_type.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.options,
    required super.maxPoints,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      type: _parseQuestionType(json['type'] as String? ?? 'MCQ'),
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      maxPoints: json['maxPoints'] as num? ?? 0,
    );
  }

  static QuestionType _parseQuestionType(String type) {
    switch (type.toUpperCase()) {
      case 'MCQ':
        return QuestionType.MCQ;
      case 'WRITING':
        return QuestionType.WRITING;
      case 'TRUE_FALSE':
        return QuestionType.TRUE_FALSE;
      default:
        return QuestionType.MCQ;
    }
  }
}
