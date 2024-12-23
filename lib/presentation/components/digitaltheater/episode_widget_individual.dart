import 'dart:typed_data';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EpisodeWidgetIndividualPage extends StatefulWidget {
  final String videoUrl;
  final int episodenumber;
  final String title;
  final String index;

  const EpisodeWidgetIndividualPage({
    super.key,
    required this.videoUrl,
    required this.episodenumber,
    required this.title,
    required this.index,
  });

  @override
  State<EpisodeWidgetIndividualPage> createState() =>
      _EpisodeWidgetIndividualPageState();
}

class _EpisodeWidgetIndividualPageState
    extends State<EpisodeWidgetIndividualPage> {
  Uint8List? thumbnailBytes;
  bool isLoading = true;
  String? youtubeThumbnailUrl;

  @override
  void initState() {
    super.initState();
    // _generateThumbnail();
  }

  // Future<void> _generateThumbnail() async {
  //   if (_isYouTubeUrl(widget.videoUrl)) {
  //     final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
  //     if (videoId != null) {
  //       youtubeThumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
  //       setState(() {
  //         isLoading = false;
  //       });
  //       return;
  //     }
  //   }
  //
  //   // If not YouTube, generate a thumbnail from the video file
  //   thumbnailBytes = await await generateThumbnail(widget.videoUrl);
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
      child: SizedBox(
          height: 80.h,
          width: 80.w,
          child: const CircularProgressIndicator()),
    )
        : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10.h,
            ),
            Container(
              height: 140.h,
              width: 180.w,
              decoration: BoxDecoration(
                image: youtubeThumbnailUrl != null
                    ? DecorationImage(
                  image: NetworkImage(youtubeThumbnailUrl!),
                  fit: BoxFit.cover,
                )
                    : thumbnailBytes != null
                    ? DecorationImage(
                  image: MemoryImage(thumbnailBytes!),
                  fit: BoxFit.cover,
                )
                    : null,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(
              width: 10.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Episode ${widget.episodenumber}",
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
                Text(widget.title),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
            SizedBox(
              width: 5.h,
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        CommonWidgets.CustomDivider(
            start: 20.w, end: 20.w, thickness: 1, color: Colors.white)
      ],
    );
  }
  // Future<Uint8List?> generateThumbnail(String videoUrl) async {
  //   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //   final String tempDir = (await getTemporaryDirectory()).path;
  //   final String thumbnailPath = '$tempDir/thumbnail.jpg';
  //
  //   try {
  //     // Generate the thumbnail using FFmpeg at 1 second of the video
  //     await _flutterFFmpeg.execute(
  //         '-i $videoUrl -ss 00:00:01.000 -vframes 1 $thumbnailPath');
  //
  //     // Check if the thumbnail file exists
  //     final File thumbnailFile = File(thumbnailPath);
  //     if (await thumbnailFile.exists()) {
  //       // Read the thumbnail file into bytes
  //       final Uint8List thumbnailBytes = await thumbnailFile.readAsBytes();
  //       return thumbnailBytes;
  //     }
  //   } catch (e) {
  //     print('Error generating thumbnail: $e');
  //   }
  //   return null;
  // }
}
