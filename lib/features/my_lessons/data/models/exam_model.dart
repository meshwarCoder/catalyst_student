class ExamModel {
  final int id;
  final int lessonId;
  final String examName;
  final int maxGrade;
  final String examDateTime;
  final String? closingDate;
  final int durationMinutes;
  final String examType;

  ExamModel({
    required this.id,
    required this.lessonId,
    required this.examName,
    required this.maxGrade,
    required this.examDateTime,
    required this.closingDate,
    required this.durationMinutes,
    required this.examType,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as int? ?? 0,
      lessonId: json['lessonId'] as int? ?? 0,
      examName: json['examName'] as String? ?? '',
      maxGrade: json['maxGrade'] as int? ?? 0,
      examDateTime: json['examDateTime'] as String? ?? '',
      closingDate: json['closingDate'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      examType: json['examType'] as String? ?? 'ONLINE',
    );
  }
}
