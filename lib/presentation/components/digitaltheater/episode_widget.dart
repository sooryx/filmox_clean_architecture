
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EpisodeWidget extends StatefulWidget {
  final String videoUrl;
  final String episodenumber;
  final String description;
  final String title;

  const EpisodeWidget({
    super.key,
    required this.videoUrl,
    required this.episodenumber,
    required this.description,
    required this.title,
  });

  @override
  _EpisodeWidgetState createState() => _EpisodeWidgetState();
}

class _EpisodeWidgetState extends State<EpisodeWidget> {
  Uint8List? _thumbnailBytes;
  String? _youtubeThumbnailUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _generateThumbnail();
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String _getYouTubeThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  // Future<void> _generateThumbnail() async {
  //   if (_isYouTubeUrl(widget.videoUrl)) {
  //     setState(() {
  //       _youtubeThumbnailUrl = _getYouTubeThumbnailUrl(widget.videoUrl);
  //       _isLoading = false;
  //     });
  //   } else {
  //     try {
  //       final thumbnailBytes = await generateThumbnail(widget.videoUrl);
  //
  //       if (thumbnailBytes != null) {
  //         setState(() {
  //           _thumbnailBytes = thumbnailBytes;
  //           _isLoading = false;
  //         });
  //       } else {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     } catch (e) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       if (kDebugMode) {
  //         print("Error generating thumbnail: $e");
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Widget URL: ${widget.videoUrl}");
    }

    if (widget.videoUrl.isEmpty) {
      return const Center(child: Text("No Episodes available"));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 140.h,
            width: 180.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _youtubeThumbnailUrl != null
                  ? Image.network(
                _youtubeThumbnailUrl!,
                fit: BoxFit.cover,
              )
                  : _thumbnailBytes != null
                  ? Image.memory(
                _thumbnailBytes!,
                fit: BoxFit.fitHeight,
              )
                  : Image.asset(
                AppConstants.filmoxLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Episode ${widget.episodenumber}",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Text(widget.title),
          SizedBox(
            width: 180.w,
            child: Text(
              widget.description,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.white.withOpacity(0.6),
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      );
    }
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
