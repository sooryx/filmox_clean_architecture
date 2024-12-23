import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final double height;
  final double width;
  final String videoUrl;
  final bool showControls;

  const YouTubePlayerWidget({
    super.key,
    required this.height,
    required this.width,
    required this.videoUrl,
    required this.showControls,
  });

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _initializeYouTubePlayer();
  }

  void _initializeYouTubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          loop: false,
        ),
      )..addListener(() {
          if (_youtubePlayerController!.value.isFullScreen) {
            _enterFullScreen();
          } else {
            _exitFullScreen();
          }
        });
    } else {
      throw Exception("Invalid YouTube URL");
    }
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    _exitFullScreen();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_youtubePlayerController!.value.isFullScreen) {
      _youtubePlayerController!.toggleFullScreenMode();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (_youtubePlayerController!.value.isFullScreen) {
          _youtubePlayerController!.toggleFullScreenMode();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          YoutubePlayer(
            controller: _youtubePlayerController!,
            showVideoProgressIndicator: widget.showControls,
            bottomActions: widget.showControls
                ? [
                    const CurrentPosition(),
                    const ProgressBar(isExpanded: true),
                    const FullScreenButton(),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}
