import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ResultHeaderWidget extends StatelessWidget {
  final String studentName;
  final String examName;
  final String statusText;
  final Color statusColor;
  final String? date;

  const ResultHeaderWidget({
    super.key,
    required this.studentName,
    required this.examName,
    required this.statusText,
    required this.statusColor,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: studentName,
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: examName,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ],
                ),
              ),
              _buildBadge(),
            ],
          ),
          if (date != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                CustomText(text: date!, fontSize: 14, color: Colors.grey[600]),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomText(
        text: statusText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: statusColor,
      ),
    );
  }
}
