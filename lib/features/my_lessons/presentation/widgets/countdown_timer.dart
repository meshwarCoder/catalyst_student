import 'dart:async';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  final TextStyle? style;
  final VoidCallback? onFinished;

  const CountdownTimer({
    super.key,
    required this.targetDate,
    this.style,
    this.onFinished,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _duration = widget.targetDate.difference(DateTime.now());
    if (_duration.isNegative) {
      _duration = Duration.zero;
      widget.onFinished?.call();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = widget.targetDate.difference(DateTime.now());
        if (_duration.isNegative) {
          _duration = Duration.zero;
          _timer.cancel();
          widget.onFinished?.call();
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = duration.inDays > 0 ? "${duration.inDays}d " : "";
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: _formatDuration(_duration),
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.redAccent,
    );
  }
}
