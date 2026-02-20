import 'package:catalyst/core/enums/student_exam_status.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_exam_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamUiState {
  final StudentExamStatus status;
  final String badgeText;
  final Color badgeColor;
  final String? statusDescription;
  final bool showButton;
  final String? buttonText;
  final Color? buttonColor;
  final bool isVerified;
  final String? gradeText;
  final String? percentageText;
  final double? progressValue;
  final Color? progressColor;

  // Formatting fields
  final String formattedDate;
  final String formattedTime;
  final String? closingFormattedTime;
  final DateTime? closingDateTime;
  final int durationMinutes;

  ExamUiState({
    required this.status,
    required this.badgeText,
    required this.badgeColor,
    this.statusDescription,
    required this.showButton,
    this.buttonText,
    this.buttonColor,
    required this.isVerified,
    this.gradeText,
    this.percentageText,
    this.progressValue,
    this.progressColor,
    required this.formattedDate,
    required this.formattedTime,
    this.closingFormattedTime,
    this.closingDateTime,
    required this.durationMinutes,
  });

  static String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      // Matching the aesthetic: "March 15 2026"
      return DateFormat('MMMM d yyyy').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  static String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  factory ExamUiState.fromEntity(StudentExamEntity entity) {
    final String formattedDate = _formatDate(entity.examDateTime);
    final String formattedTime = _formatTime(entity.examDateTime);
    final DateTime? closingDateTime = entity.closingDate != null
        ? DateTime.tryParse(entity.closingDate!)
        : null;

    switch (entity.status) {
      case StudentExamStatus.upcoming:
        return ExamUiState(
          status: entity.status,
          badgeText: 'Not started yet',
          badgeColor: const Color(0xFF5D8BF4), // Blue-ish
          showButton: false,
          isVerified: false,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          durationMinutes: entity.durationMinutes,
        );
      case StudentExamStatus.active:
        return ExamUiState(
          status: entity.status,
          badgeText: 'Available Now',
          badgeColor: const Color(0xFF4CAF50), // Green
          showButton: true,
          buttonText: 'Start Exam',
          buttonColor: const Color(0xFF6200EE), // Purple/Violet
          isVerified: false,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          closingDateTime: closingDateTime,
          durationMinutes: entity.durationMinutes,
        );
      case StudentExamStatus.pending:
        return ExamUiState(
          status: entity.status,
          badgeText: 'Submitted',
          badgeColor: const Color(0xFFFFC107), // Amber/Yellow
          statusDescription: 'Waiting for result announcement',
          showButton: false,
          isVerified: false,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          durationMinutes: entity.durationMinutes,
        );
      case StudentExamStatus.verified:
        final double score = entity.studentGrade?.toDouble() ?? 0.0;
        final double progress = entity.maxGrade > 0
            ? score / entity.maxGrade
            : 0.0;
        final Color progressColor = progress >= 0.5 ? Colors.green : Colors.red;
        return ExamUiState(
          status: entity.status,
          badgeText: 'Result Announced',
          badgeColor: const Color(0xFF9C27B0), // Purple
          showButton: true,
          buttonText: 'View Details',
          buttonColor: const Color(0xFFF5F5F7), // Light grey matching Figma
          isVerified: true,
          gradeText: '${score.toInt()} / ${entity.maxGrade}',
          percentageText: '${(progress * 100).toInt()}%',
          progressValue: progress,
          progressColor: progressColor,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          durationMinutes: entity.durationMinutes,
        );
      case StudentExamStatus.missed:
        final double score = entity.studentGrade?.toDouble() ?? 0.0;
        return ExamUiState(
          status: entity.status,
          badgeText: 'Absent',
          badgeColor: const Color(0xFFE57373), // Soft Red
          statusDescription: 'Exam time ended',
          showButton: false,
          isVerified: false,
          gradeText: '${score.toInt()} / ${entity.maxGrade}',
          percentageText: '0%',
          progressValue: 0,
          progressColor: Colors.red,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
          durationMinutes: entity.durationMinutes,
        );
    }
  }
}
