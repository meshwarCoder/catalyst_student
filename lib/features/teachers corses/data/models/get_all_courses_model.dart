class AllLessonsResponse {
  final bool success;
  final String message;
  final List<Lesson> data;

  const AllLessonsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllLessonsResponse.fromJson(Map<String, dynamic> json) {
    return AllLessonsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class Lesson {
  final int id;
  final String subject;
  final int studentsCount;
  final Teacher teacher;
  final List<Schedule> schedules;

  const Lesson({
    required this.id,
    required this.subject,
    required this.studentsCount,
    required this.teacher,
    required this.schedules,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int? ?? 0,
      subject: json['subject'] as String? ?? '',
      studentsCount: json['studentsCount'] as int? ?? 0,
      teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>? ?? {}),
      schedules:
          (json['schedules'] as List<dynamic>?)
              ?.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class Teacher {
  final int id;
  final String fullName;

  const Teacher({required this.id, required this.fullName});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
    );
  }
}

class Schedule {
  final int? id;
  final String? day;
  final String? time;

  const Schedule({this.id, this.day, this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as int?,
      day: json['day'] as String?,
      time: json['time'] as String?,
    );
  }
}
