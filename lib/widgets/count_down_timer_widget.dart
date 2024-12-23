import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownText extends StatefulWidget {
  final Duration countdownDuration;
  final String countdownText;
  final TextStyle? textStyle;
  final TextStyle? labeStyle;
  final TextStyle? titleStyle;
  final bool enableBg;
  final double? fontSize;
  const CountdownText({
    Key? key,
    required this.countdownDuration,
    required this.countdownText,
    this.textStyle,
    this.labeStyle,  this.enableBg = false, this.titleStyle, this.fontSize,
  }) : super(key: key);

  @override
  _CountdownTextState createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.countdownDuration;

    // Initialize the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Breakdown the duration into days, hours, minutes, and seconds
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.countdownText == ''
            ? SizedBox.shrink()
            : Text(
          widget.countdownText,
          style: widget.titleStyle ?? GoogleFonts.dotGothic16(
            fontSize: widget.fontSize ?? 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (days > 0) _buildTimeColumn(days, 'Days'),
            if (days > 0) const SizedBox(width: 10),
            if (hours > 0 || days > 0) _buildTimeColumn(hours, 'Hours'),
            if ((hours > 0 || days > 0)) const SizedBox(width: 10),
            if (minutes > 0 || hours > 0 || days > 0)
              _buildTimeColumn(minutes, 'Mins'),
            if ((minutes > 0 || hours > 0 || days > 0))
              const SizedBox(width: 10),
            if (seconds > 0 || minutes > 0 || hours > 0 || days > 0)
              _buildTimeColumn(seconds, 'Sec'),
          ],
        ),
      ],
    );
  }

  // Helper method to build time column
  Widget _buildTimeColumn(int timeValue, String label) {
    return Container(
      padding: widget.enableBg ? EdgeInsets.all(10.dg) : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color:widget.enableBg ? Colors.grey.withOpacity(0.2) : Colors.transparent,

      ),
      child: Column(
        children: [
          Text(
            timeValue.toString().padLeft(2, '0'),
            style: widget.textStyle ??
                GoogleFonts.dotGothic16(
                  fontSize: widget.fontSize ?? 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
          ),
          Text(
            label,
            style: widget.labeStyle ?? GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
