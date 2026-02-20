import 'package:catalyst/core/enums/student_exam_status.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my_lessons/domain/entities/student_exam_entity.dart';
import 'package:catalyst/features/my_lessons/presentation/models/exam_ui_state.dart';
import 'package:catalyst/features/my_lessons/presentation/widgets/countdown_timer.dart';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final StudentExamEntity exam;
  final VoidCallback? onButtonTap;

  const ExamCard({super.key, required this.exam, this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    final uiState = ExamUiState.fromEntity(exam);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Exam Name and Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    text: exam.examName,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                    height: 1.2,
                  ),
                ),
                _buildBadge(uiState),
              ],
            ),
            const SizedBox(height: 20),

            // Content based on state
            _buildStateContent(uiState),

            // Action Button
            if (uiState.showButton) ...[
              const SizedBox(height: 20),
              _buildActionButton(uiState),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStateContent(ExamUiState uiState) {
    switch (uiState.status) {
      case StudentExamStatus.upcoming:
        return _buildUpcomingContent(uiState);
      case StudentExamStatus.active:
        return _buildActiveContent(uiState);
      case StudentExamStatus.pending:
        return _buildPendingContent(uiState);
      case StudentExamStatus.verified:
        return _buildVerifiedContent(uiState);
      case StudentExamStatus.missed:
        return _buildMissedContent(uiState);
    }
  }

  Widget _buildUpcomingContent(ExamUiState uiState) {
    return Column(
      children: [
        _buildInfoRow(Icons.calendar_today_outlined, uiState.formattedDate),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.access_time, uiState.formattedTime),
      ],
    );
  }

  Widget _buildActiveContent(ExamUiState uiState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9), // Light green
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCEDC8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Time Remaining',
            fontSize: 13,
            color: Colors.green[800],
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer_outlined, color: Colors.green[800], size: 24),
              const SizedBox(width: 10),
              if (uiState.closingDateTime != null)
                CountdownTimer(targetDate: uiState.closingDateTime!)
              else
                const CustomText(
                  text: 'N/A',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingContent(ExamUiState uiState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: uiState.statusDescription ?? '',
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildVerifiedContent(ExamUiState uiState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: uiState.gradeText ?? '',
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: uiState.progressColor ?? AppColors.text,
                ),
                if (uiState.percentageText != null)
                  CustomText(
                    text: uiState.percentageText!,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: uiState.progressColor ?? Colors.grey,
                  ),
              ],
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: uiState.progressValue ?? 0,
                    backgroundColor: (uiState.progressColor ?? Colors.grey)
                        .withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      uiState.progressColor ?? Colors.grey,
                    ),
                    strokeWidth: 8,
                  ),
                  Center(
                    child: CustomText(
                      text: uiState.percentageText ?? '',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: uiState.progressColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: uiState.progressValue ?? 0,
            backgroundColor: (uiState.progressColor ?? Colors.grey).withOpacity(
              0.1,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(
              uiState.progressColor ?? Colors.grey,
            ),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMissedContent(ExamUiState uiState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            CustomText(
              text: uiState.statusDescription ?? '',
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomText(
          text: uiState.gradeText ?? '',
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.red[300],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: 0,
            backgroundColor: Colors.red.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(ExamUiState uiState) {
    final text = uiState.badgeText;
    final color = uiState.badgeColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            uiState.status == StudentExamStatus.verified
                ? Icons.check_circle_outline
                : uiState.status == StudentExamStatus.missed
                ? Icons.cancel_outlined
                : Icons.info_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          CustomText(
            text: text,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 10),
        CustomText(
          text: text,
          fontSize: 15,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildActionButton(ExamUiState uiState) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.color1,
          borderRadius: BorderRadius.circular(14),
          gradient: null,
          boxShadow: uiState.status == StudentExamStatus.active
              ? [
                  BoxShadow(
                    color: AppColors.color1.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: uiState.buttonText ?? '',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
