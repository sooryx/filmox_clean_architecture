
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultCards extends StatelessWidget {
  final String name;
  final String vote;
  final String image;
  final String? judgeReview;
  final bool selectedByJudge;

  const ResultCards({
    super.key,
    required this.name,
    required this.vote,
    required this.image,
    required this.selectedByJudge,
    this.judgeReview,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> yellow = [
      const Color(0xFFFCCF3A).withOpacity(1),
      const Color(0xFFDE791E).withOpacity(0.6),
      const Color(0xFFEA5A6F).withOpacity(0.2),
    ];
    List<Color> green = [
      const Color(0xFF63FD88).withOpacity(1),
      const Color(0xFF33C58E).withOpacity(0.6),
      const Color(0xFF276174).withOpacity(0.2),
    ];
    List<Color> color = selectedByJudge ? yellow : green;

    return Container(
      margin:  EdgeInsets.only(left: 5.w, right: 5.w, bottom: 13.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: color,
        ),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: color[0], width: 1),
        boxShadow: [
          BoxShadow(
            color: color[0].withOpacity(0.3),
            offset: const Offset(0.0, 6.0),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding:
        EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 15.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(color: Colors.white, width: 0.3),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.35),
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                      ),
                      child: Text(
                        'Votes : $vote',
                        style:  TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                selectedByJudge
                    ? GestureDetector(
                  onTap: () {
                    _showVideoDialog(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: color[0], width: 2.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: color[0],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Judge review",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
                Container(
                  height: 60.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(-4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 5.0,
                      ),
                      BoxShadow(
                        color: color[0],
                        offset: const Offset(4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: color[0], width: 2.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.person,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  void _showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              VideoPlayerWidget(
                loadingWidget: const Loadingscreen(),
                url: UrlStrings.videoUrl + judgeReview!,
                showControls: true,
                width: MediaQuery.of(context).size.width - 120.w,
                height: 350.h,
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

