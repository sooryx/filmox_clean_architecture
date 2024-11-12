import 'dart:io';
import 'dart:typed_data';
import 'package:filmox_clean_architecture/domain/entity/contest/contest_entity.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rclive/rcupload/rc_upload_screen.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail_slider/frame_utils.dart';
import 'package:video_thumbnail_slider/video_thumbnail_slider.dart';

class ThumbnailSelectorScreen extends StatefulWidget {
  final File media;
  final ContestEntity currentContest;
  bool? fromEditScreen;

  ThumbnailSelectorScreen({required this.media,
    super.key,
    required this.currentContest,
    this.fromEditScreen});

  @override
  State<ThumbnailSelectorScreen> createState() =>
      _ThumbnailSelectorScreenState();
}

class _ThumbnailSelectorScreenState extends State<ThumbnailSelectorScreen> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.file(widget.media);
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    await videoController.initialize();
    setState(() {}); // Ensure the UI updates once the video is initialized
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _buildBody(context),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Theme
                .of(context)
                .colorScheme
                .surface),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        "Pick thumbnail for your contest",
        style: Theme
            .of(context)
            .textTheme
            .bodyMedium,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Choose how your contest will appear for others. Select a frame from your video as a cover image.",
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.h),
        _buildVideoPlayer(context),
        SizedBox(height: 20.h),
        _buildThumbnailSlider(context),
        SizedBox(height: 30.h,),

      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return FutureBuilder(
      future: videoController.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildThumbnailSlider(BuildContext context) {
    final provider = Provider.of<RcUploadProvider>(context);

    return Column(
      children: [
        VideoThumbnailSlider(
          controller: videoController,
          splitImage: 15,
          height: 80,
          width: MediaQuery
              .of(context)
              .size
              .width - 20,
          backgroundColor: const Color(0xff474545),
          frameBuilder: (imgData) =>
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                child: Image.memory(
                  imgData,
                  fit: BoxFit.cover,
                ),
              ),
          customCurrentFrameBuilder: (videoController) =>
              GestureDetector(
                onTap: () async {
                  final thumbnailFile = await _getThumbnailFromCurrentPosition(
                      videoController);
                  provider.selectThumbnailFile (thumbnailFile);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                  child: VideoPlayer(videoController),
                ),
              ),
        ),
        SizedBox(height: 50.h),
        provider.thumbnail == null ? Text(
          "Drag to the frame, and tap to choose the thumbnail", style: Theme
            .of(context)
            .textTheme
            .bodySmall,)
            :Text(
          "Great !!", style: Theme
            .of(context)
            .textTheme
            .bodySmall,),

      ],
    );
  }


  Widget _buildBottomNavBar(BuildContext context) {
    final provider = Provider.of<RcUploadProvider>(
        context, listen: false);

    return SizedBox(
      height: 80.h,
      child: Column(
        children: [
          CommonWidgets.roundButton(
            color: Colors.blue,
            onTap: () {
              if (provider.thumbnail == null) {
                customErrorToast(context, "Choose a thumbnail");
              } else {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        MediaUploadWidget(
                          contest: widget.currentContest,
                          isNewUpload: true,
                        ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Text(
            "Continue",
            style: Theme
                .of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }

  Future<File> _getThumbnailFromCurrentPosition(
      VideoPlayerController videoController) async {
    final currentPosition = videoController.value.position;
    final result = await FrameUtils().getListThumbnailIsolate(
      videoPath: videoController.dataSource,
      duration: currentPosition,
      split: 1,
    );
    return await _writeImgDataToFile(result.first);
  }

  Future<File> _writeImgDataToFile(Uint8List imgData) async {
    final directory = await getTemporaryDirectory();
    final path = join(directory.path, 'thumbnail.png');
    return File(path)
      ..writeAsBytesSync(imgData);
  }
}

class FittedVideoPlayer extends StatefulWidget {
  const FittedVideoPlayer({required this.controller,
    this.height = 300,
    super.key,
    required this.context});

  final VideoPlayerController controller;
  final double height;
  final BuildContext context;

  @override
  State<FittedVideoPlayer> createState() => _FittedVideoPlayerState();
}

class _FittedVideoPlayerState extends State<FittedVideoPlayer> {
  late double width = MediaQuery
      .of(widget.context)
      .size
      .width;
  late double height = widget.height;

  void getVideoRatio() {
    if (widget.controller.value.isInitialized) {
      updateWidthHeight();
    }
  }

  void updateWidthHeight() {
    final ratio = widget.controller.value.aspectRatio;
    if (height * ratio <= width) {
      width = height * ratio;
    } else {
      height = width / ratio;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    updateWidthHeight();
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: VideoPlayerView(
          videoController: widget.controller,
        ),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView(
      {this.videoController, this.media, this.autoPlay = true, super.key});

  final VideoPlayerController? videoController;
  final File? media;
  final bool autoPlay;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerController _videoController =
      widget.videoController ?? VideoPlayerController.file(widget.media!);

  @override
  void initState() {
    initVideoController();
    super.initState();
  }

  void initVideoController() async {
    if (!_videoController.value.isInitialized) {
      await _videoController.initialize();
    }
    setState(() {});
    if (widget.autoPlay) {
      _videoController.play();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void onVideoTap() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onVideoTap,
      child: VideoPlayer(_videoController),
    );
  }
}
