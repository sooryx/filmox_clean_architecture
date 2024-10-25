import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:filmox_clean_architecture/widgets/youtube_video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndividualVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final bool isYoutube;
  final String title;

  const IndividualVideoPlayer(
      {super.key,
      required this.videoUrl,
      required this.title,
      required this.isYoutube});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(title),
        ),
        body: SizedBox(
            // height: 240.h,
            // width: MediaQuery.of(context).size.width,
            child: isYoutube
                ? YouTubePlayerWidget(
                height: 240.h,
                width: MediaQuery.of(context).size.width,
                videoUrl: videoUrl,
                showControls: true)
                : VideoPlayerWidget(
                height: 240.h,
                width: MediaQuery.of(context).size.width,
                url: videoUrl,
                loadingWidget: Loadingscreen())
        ));
  }
}
