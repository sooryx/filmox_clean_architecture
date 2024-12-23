import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/rounds/rounds_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rounds/rc_rounds_main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RoundsBanner extends StatefulWidget {
  final String title;
  final String image;
  final DateTime voteDate;
  final DateTime endDate;
  final String description;
  final Color color;
  final int index;
  final bool isCompleted;
  final bool isVideo;

  const RoundsBanner({
    super.key,
    required this.title,
    required this.image,
    required this.voteDate,
    required this.endDate,
    required this.description,
    required this.color,
    required this.index,
    required this.isCompleted,
    required this.isVideo,
  });

  @override
  _RoundsBannerState createState() => _RoundsBannerState();
}

class _RoundsBannerState extends State<RoundsBanner> {
  bool _isCollapsed = true;

  String timeRemaining(DateTime targetDate) {
    DateTime now = DateTime.now();
    Duration difference = targetDate.difference(now);

    if (difference.isNegative) {
      return "The date has already passed.";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours remaining";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes remaining";
    } else {
      return "Less than a minute remaining";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<RcRoundsMainProvider>(context, listen: true);
    List<RoundsEntity> roundsList = provider.roundsEntity;
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
                Hero(
                  tag: 'bg',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    height: _isCollapsed ? 90.h : 250.h,
                    width: double.infinity,
                    margin: EdgeInsets.all(12.dg),
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      image: DecorationImage(
                          image:
                          NetworkImage(UrlStrings.imageUrl + widget.image),
                          fit: BoxFit.cover,
                          opacity: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isCollapsed
                            ? Colors.black54
                            : widget.color.withOpacity(0.5),
                        width: 1.5,
                      ),
                      gradient: LinearGradient(
                        colors: _isCollapsed
                            ? [
                          widget.color.withOpacity(0.2),
                          widget.color.withOpacity(0.4),
                        ]
                            : [
                          Colors.black54,
                          Colors.black54,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isCollapsed
                              ? Colors.black54.withOpacity(0.3)
                              : widget.color.withOpacity(0.2),
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
                                  color: Colors.white54,
                                  shape: BoxShape.circle),
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
                              Expanded(
                                child: Text(
                                  "${timeRemaining(widget.voteDate)}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            widget.description,
                            overflow: TextOverflow.ellipsis,
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
                                InkWell(
                                  onTap: () {
                                    DateTime now = DateTime.now();

                                    if (now.isAfter(widget.voteDate) && now.isBefore(widget.endDate)) {
                                      // Navigate to RcRoundFeedScreen when vote date has started but before end date
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (context) => RcRoundFeedScreen(
                                      //       roundID: provider.activeRound!.roundID.toString(),
                                      //       contestID: provider.activeRound!.contestID.toString(),
                                      //       poster: provider.activeRound!.poster,
                                      //     ),
                                      //   ),
                                      // );
                                    } else if (now.isAfter(widget.endDate)) {
                                      // Navigate to RcRoundResults when end date has passed
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (context) => RcRoundResults(
                                      //       contestId: provider.activeRound!.contestID,
                                      //       roundId: provider.activeRound!.roundID,
                                      //     ),
                                      //   ),
                                      // );
                                    } else {
                                      // Navigate to RoundInfoScreen if vote date or end date has not started
                                      // Navigator.push(
                                      //   context,
                                      //   CupertinoPageRoute(
                                      //     builder: (context) => RoundInfoScreen(
                                      //       round: provider.activeRound!,
                                      //       allRound: roundsList,
                                      //       uploadType: widget.uploadType,
                                      //     ),
                                      //   ),
                                      // );
                                    }
                                  },

                                  child: Container(
                                    padding: EdgeInsets.all(5.dg),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
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
