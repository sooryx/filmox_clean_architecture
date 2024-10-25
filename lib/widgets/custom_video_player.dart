
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'loading_screen.dart';

class VideoPlayerWidget extends StatefulWidget {
  final double height;
  final double width;
  final String url;
  final Widget loadingWidget;
  final bool? showControls;
  final bool? autoPlay;

  const VideoPlayerWidget({super.key,
    required this.height,
    required this.width,
    required this.url,
    required this.loadingWidget, this.showControls, this.autoPlay,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: widget.autoPlay ?? false,
            looping: false,
            showControlsOnInitialize: true,
            showControls: widget.showControls ?? true,
            allowFullScreen: true,
            fullScreenByDefault: false,
            materialProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              bufferedColor: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          );
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _chewieController != null
            ? _isFullScreen
            ? Scaffold(
          appBar: AppBar(
            title: const Text('Video Player'),
            actions: [
              IconButton(
                icon: const Icon(Icons.fullscreen_exit),
                onPressed: () => setState(() => _isFullScreen = false),
              ),
            ],
          ),
          body: Center(
            child: Chewie(controller: _chewieController!),
          ),
        )
            : AspectRatio(
          aspectRatio: 4/3,
          child: Chewie(controller: _chewieController!),
        )
            : SizedBox(
          height: widget.height,
          width: widget.width,
          child: widget.loadingWidget,
        ),

      ],
    );
  }


  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}





class CustomControls extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPauseToggle;

  const CustomControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPauseToggle,
  });

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  bool _isVisible = false; // Track visibility of the play/pause icon

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleVisibility,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isVisible)
            GestureDetector(
              onTap: () {
                widget.onPlayPauseToggle();
                _toggleVisibility();
              },
              child: Center(
                child: Icon(
                  widget.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
        ],
      ),
    );
  }
}





class BannerVideoPlayerWithControls extends StatefulWidget {
  final String videoUrl;

  const BannerVideoPlayerWithControls({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _BannerVideoPlayerWithControlsState createState() => _BannerVideoPlayerWithControlsState();
}

class _BannerVideoPlayerWithControlsState extends State<BannerVideoPlayerWithControls> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: 16/9,
          child: VideoPlayer(_controller),
        )
            : Center(child: Loadingscreen()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ],
    );
  }
}




