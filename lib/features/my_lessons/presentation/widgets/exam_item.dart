import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/custom_snackbar.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my_lessons/data/models/exam_model.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/utils/time_service.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExamItem extends StatefulWidget {
  final ExamModel exam;
  const ExamItem({super.key, required this.exam});

  @override
  State<ExamItem> createState() => _ExamItemState();
}

class _ExamItemState extends State<ExamItem> {
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkSubmissionStatus();
  }

  Future<void> _checkSubmissionStatus() async {
    final status = await CacheHelper.getData(
      key: 'exam_submitted_${widget.exam.id}',
    );
    if (status != null && status == true) {
      if (mounted) {
        setState(() {
          _isSubmitted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse dates
    DateTime now = getIt<TimeService>().now;
    DateTime? startDateTime = DateTime.tryParse(widget.exam.examDateTime);
    DateTime? endDateTime = widget.exam.closingDate != null
        ? DateTime.tryParse(widget.exam.closingDate!)
        : null;

    String formattedStartDate = startDateTime != null
        ? DateFormat('MMM dd, hh:mm a').format(startDateTime)
        : 'N/A';
    String formattedEndDate = endDateTime != null
        ? DateFormat('MMM dd, hh:mm a').format(endDateTime)
        : 'No Deadline';

    bool isNotStarted = startDateTime != null
        ? now.isBefore(startDateTime)
        : false;
    bool isExpired = endDateTime != null ? now.isAfter(endDateTime) : false;
    bool isOpen = !isNotStarted && !isExpired && !_isSubmitted;

    Color statusColor;
    String statusText;
    if (_isSubmitted) {
      statusColor = Colors.teal;
      statusText = "Completed";
    } else if (isNotStarted) {
      statusColor = Colors.orange;
      statusText = "Not Started";
    } else if (isExpired) {
      statusColor = Colors.red;
      statusText = "Finished";
    } else {
      statusColor = Colors.green;
      statusText = "Open";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(statusText, statusColor),
                      Row(
                        children: [
                          const Icon(
                            Icons.stars,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            text: "${widget.exam.maxGrade} pts",
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: widget.exam.examName,
                    color: AppColors.color1,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.color1.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      text: "Exam Mode: ${widget.exam.examType}",
                      color: AppColors.color1.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, thickness: 1.2),
                  const SizedBox(height: 24),

                  // Professional Time Grid
                  _buildTimeSection(
                    label: "Available From",
                    value: formattedStartDate,
                    icon: Icons.play_circle_outline_rounded,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildTimeSection(
                    label: "Deadline / Closes",
                    value: formattedEndDate,
                    icon: Icons.event_busy_rounded,
                    iconColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  _buildTimeSection(
                    label: "Total Time Limit",
                    value: "${widget.exam.durationMinutes} Minutes",
                    icon: Icons.timer_outlined,
                    iconColor: Colors.blueAccent,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: isOpen
                  ? () => GoRouter.of(
                      context,
                    ).push(Routs.examQuestions, extra: widget.exam.id)
                  : () => CustomSnackBar.show(
                      context,
                      message: _isSubmitted
                          ? "You have already submitted this exam."
                          : isNotStarted
                          ? "This exam has not started yet."
                          : "This exam is already finished.",
                      isError: true,
                    ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: isOpen
                      ? AppColors.color1
                      : (_isSubmitted ? Colors.teal : Colors.grey.shade200),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: isOpen
                      ? [
                          BoxShadow(
                            color: AppColors.color1.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isOpen)
                        const Icon(
                          Icons.login_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      if (isOpen) const SizedBox(width: 8),
                      CustomText(
                        text: _isSubmitted
                            ? "EXAM COMPLETED"
                            : (isOpen ? "START EXAM NOW" : "NOT AVAILABLE"),
                        color: (isOpen || _isSubmitted)
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              color: AppColors.text.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 2),
            CustomText(
              text: value,
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: CustomText(
        text: text.toUpperCase(),
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }
}
