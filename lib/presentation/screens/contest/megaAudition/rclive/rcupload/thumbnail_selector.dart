// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rclive/rcupload/rc_upload_screen.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart'; // Import video_thumbnail package

class ThumbnailSelector extends StatefulWidget {
  final File media;
  final ContestEntity currentContest;
  bool? fromEditScreen;

  ThumbnailSelector(
      {required this.media, super.key, required this.currentContest,this.fromEditScreen});

  @override
  _ThumbnailSelectorState createState() => _ThumbnailSelectorState();
}

class _ThumbnailSelectorState extends State<ThumbnailSelector> {
  late VideoPlayerController _controller;
  late List<Uint8List> thumbnails;
  int? selectedIndex;
  Uint8List? selectedThumbnail;
  double progress = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.media)
      ..initialize().then((_) {
        setState(() {});
      });
    thumbnails = [];
    generateThumbnails();
  }

  Future<void> generateThumbnails() async {
    final videoFile = widget.media;
    const thumbnailCount = 60;

    for (int i = 0; i < thumbnailCount; i++) {
      final time = (i + 1) * 2;
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 100,
        maxWidth: 100,
        quality: 75,
        timeMs: time * 1000,
      );

      if (thumbnail != null) {
        thumbnails.add(thumbnail);
      }

      setState(() {
        progress = (i + 1) / thumbnailCount;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void onThumbnailSelected(int index, Uint8List imgData) async {
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);
    setState(() {
      selectedIndex = index;
      selectedThumbnail = imgData;
      _controller.seekTo(Duration(milliseconds: (index + 1) * 2000));
    });
    provider.selectThumbnailFile (await _generateFile(selectedThumbnail!, 'thumbnail'));
  }

  Future<File> _generateFile(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(data);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomnavbar(context),
      appBar: AppBar(
        title: const Text("Choose thumbnail"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SizedBox(
                height: 350.h,
                child: VideoPlayerView(
                  videoPlayerController: _controller,
                  media: widget.media,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading) _buildLoadingProgress(),
            if (!isLoading) _buildThumbnailList(),
            _buildNoThumbnailSelected(selectedThumbnail != null),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildLoadingProgress() {
    String progressMessage;

    if (progress < 0.2) {
      progressMessage = "Starting up, please hold on!";
    } else if (progress < 0.4) {
      progressMessage = "Just getting started, hang tight!";
    } else if (progress < 0.6) {
      progressMessage = "Working hard, almost there!";
    } else if (progress < 0.8) {
      progressMessage = "Almost done, thank you for your patience!";
    } else {
      progressMessage = "Setting up things for you, please wait!";
    }

    return Column(
      children: [
        SizedBox(
          height: 8.h,
          width: 250.w,
          child: LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(10.r),
            backgroundColor: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Text('${(progress * 100).toStringAsFixed(0)}%'),
        Text(progressMessage)
            .animate()
            .slideY(begin: 1, end: 0, delay: 300.ms, duration: 400.ms),
      ],
    );
  }


  Widget _buildThumbnailList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
        child: Row(
          children: thumbnails.asMap().entries.map((entry) {
            int index = entry.key;
            Uint8List imgData = entry.value;
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onThumbnailSelected(index, imgData),
              child: AnimatedContainer(
                margin: const EdgeInsets.only(right: 4),
                duration: 400.ms,
                width: 50.w,
                height: 60.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(imgData),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blueAccent
                        : Colors.black.withOpacity(0.1),
                    width: isSelected ? 4.0 : 0.5,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 6.0)
                  ]
                      : [],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNoThumbnailSelected(bool selected) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          selected
              ? const Text("Great tap the button below to proceed")
              : const Text('Choose a frame as cover image for your contest'),
        ],
      ),
    );
  }


  _buildBottomnavbar(BuildContext context) {
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: SizedBox(
        height: 60.h,
        child: CommonWidgets.roundButton(
          color: Colors.blue,
          onTap: () {
            if (provider.thumbnail == null || provider.mediaFile == null) {
              customErrorToast(context, "Choose a thumbnail");
            } else {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RcUploadScreen(
                    contest: widget.currentContest,
                    fromEditScreen: widget.fromEditScreen,
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  final File media;
  final VideoPlayerController videoPlayerController;

  const VideoPlayerView(
      {required this.media, super.key, required this.videoPlayerController});

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.videoPlayerController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        if (widget.videoPlayerController.value.isPlaying) {
          widget.videoPlayerController.pause();
        } else {
          widget.videoPlayerController.play();
        }
      },
      child: VideoPlayer(widget.videoPlayerController),
    );
  }
}
