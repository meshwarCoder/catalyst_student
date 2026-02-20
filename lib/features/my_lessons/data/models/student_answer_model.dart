import '../../domain/entities/student_answer_entity.dart';
import 'question_model.dart';

class StudentAnswerModel extends StudentAnswerEntity {
  const StudentAnswerModel({
    required super.id,
    required super.question,
    required super.selectedOptions,
    super.textAnswer,
    required super.mark,
  });

  factory StudentAnswerModel.fromJson(Map<String, dynamic> json) {
    return StudentAnswerModel(
      id: json['id'] as int? ?? 0,
      question: QuestionModel.fromJson(
        json['question'] as Map<String, dynamic>,
      ),
      selectedOptions:
          (json['selectedOptions'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt() ?? 0)
              .toList() ??
          [],
      textAnswer: json['textAnswer'] as String?,
      mark: json['mark'] as num? ?? 0,
    );
  }
}
