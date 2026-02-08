class ExamDetailsModel {
  final int id;
  final int lessonId;
  final String examName;
  final int maxGrade;
  final String examDateTime;
  final String closingDate;
  final int durationMinutes;
  final String examType;
  final List<QuestionModel> questions;

  ExamDetailsModel({
    required this.id,
    required this.lessonId,
    required this.examName,
    required this.maxGrade,
    required this.examDateTime,
    required this.closingDate,
    required this.durationMinutes,
    required this.examType,
    required this.questions,
  });

  factory ExamDetailsModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailsModel(
      id: json['id'] as int? ?? 0,
      lessonId: json['lessonId'] as int? ?? 0,
      examName: json['examName'] as String? ?? '',
      maxGrade: json['maxGrade'] as int? ?? 0,
      examDateTime: json['examDateTime'] as String? ?? '',
      closingDate: json['closingDate'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      examType: json['examType'] as String? ?? 'ONLINE',
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class QuestionModel {
  final int id;
  final String text;
  final String type; // MCQ, TRUE_FALSE, TEXT
  final List<String> options;
  final int maxPoints;

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.maxPoints,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'MCQ',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      maxPoints: json['maxPoints'] as int? ?? 0,
    );
  }
}
