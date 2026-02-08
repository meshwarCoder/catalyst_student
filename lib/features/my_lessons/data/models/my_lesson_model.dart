class MyLessonModel {
  final int id;
  final String subject;
  final MyTeacher teacher;
  final List<MySchedule> lessonSchedules;

  MyLessonModel({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.lessonSchedules,
  });

  factory MyLessonModel.fromJson(Map<String, dynamic> json) {
    return MyLessonModel(
      id: json['id'] as int? ?? 0,
      subject: json['subject'] as String? ?? '',
      teacher: MyTeacher.fromJson(
        json['teacher'] as Map<String, dynamic>? ?? {},
      ),
      lessonSchedules:
          (json['lessonSchedules'] as List<dynamic>?)
              ?.map((e) => MySchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MyTeacher {
  final int id;
  final String name;

  MyTeacher({required this.id, required this.name});

  factory MyTeacher.fromJson(Map<String, dynamic> json) {
    return MyTeacher(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class MySchedule {
  final String startTime;
  final String day;
  final int duration;

  MySchedule({
    required this.startTime,
    required this.day,
    required this.duration,
  });

  factory MySchedule.fromJson(Map<String, dynamic> json) {
    return MySchedule(
      startTime: json['startTime'] as String? ?? '',
      day: json['day'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
    );
  }
}
