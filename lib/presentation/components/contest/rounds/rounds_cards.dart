import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundsBanner extends StatefulWidget {
  final String title;
  final String remainingDays;
  final String description;
  final Color color;
  final int index;
  final bool isCompleted;

  const RoundsBanner({
    super.key,
    required this.title,
    required this.remainingDays,
    required this.description,
    required this.color,
    required this.index,
    required this.isCompleted,
  });

  @override
  _RoundsBannerState createState() => _RoundsBannerState();
}

class _RoundsBannerState extends State<RoundsBanner> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: widget.color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20.r),
      onTap: () {
        setState(() {
          _isCollapsed = !_isCollapsed;
        });
      },
      child: Row(
        children: [
          Text(
            widget.index.toString(),
            style: GoogleFonts.shizuru(fontSize: 40.sp),
          ),
          Expanded(
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  height: _isCollapsed ? 80.h : 250.h,
                  width: double.infinity,
                  margin: EdgeInsets.all(12.dg),
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isCollapsed? Colors.black54 :widget.color.withOpacity(0.5),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: _isCollapsed ?[
                        widget.color.withOpacity(0.2),
                        widget.color.withOpacity(0.4),
                      ] : [
                        Colors.black54,
                        Colors.black54,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isCollapsed ? Colors.black54.withOpacity(0.3) :widget.color.withOpacity(0.2),
                        blurRadius: 25,
                        spreadRadius: 8,
                        offset: const Offset(0, 10),
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
                            child: Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15,
                                    color: widget.color,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8.dg),
                            decoration: const BoxDecoration(
                                color: Colors.white54, shape: BoxShape.circle),
                            child: widget.isCompleted
                                ? const Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                                : Icon(
                              _isCollapsed
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up,
                              color: Colors.black,
                              size: 26.sp,
                            ),
                          )
                        ],
                      ),
                      if (!_isCollapsed) ...[
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Starts in ${widget.remainingDays} Days",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Round No. ${widget.index}",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          widget.description,
                          style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                            fontSize: 15.sp,
                          ),
                        ).animate().fadeIn(duration: 350.ms),
                        const Spacer(),
                        SizedBox(
                          width: 280.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Entries will be judged based on originality and quality.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: Colors.white54,
                                    fontSize: 13.sp,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 300.ms, duration: 400.ms),
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Tap",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: Colors.white54,
                                      fontSize: 13.sp,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
