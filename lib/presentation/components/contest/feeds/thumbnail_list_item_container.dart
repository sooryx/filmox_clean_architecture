import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'vote_widget.dart';



class ThumbnailListItemContainer extends StatefulWidget {
  final String mediaUrl;
  final String thumbnailUrl; // Thumbnail URL
  final bool isActive;
  final bool isVideo;
  final ContestMediaitemsEntity currentContest;

  const ThumbnailListItemContainer({
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.isActive,
    required this.isVideo,
    super.key,
    required this.currentContest,
  });

  @override
  _ThumbnailListItemContainerState createState() =>
      _ThumbnailListItemContainerState();
}

class _ThumbnailListItemContainerState
    extends State<ThumbnailListItemContainer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoController =
    VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: true,
              aspectRatio: _videoController!.value.aspectRatio,
              materialProgressColors: ChewieProgressColors(
                playedColor: Theme.of(context).primaryColor,
                handleColor: Theme.of(context).colorScheme.surface,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey,
              ),
              placeholder: Container(color: Colors.black),
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)),
                );
              },
            );
            _isVideoInitialized = true;
            // Automatically play if the widget is active
            if (widget.isActive) {
              _videoController?.pause();
            }
          });
        }
      }).catchError((error) {
        print("Error initializing video: $error");
      });
  }

  @override
  void didUpdateWidget(covariant ThumbnailListItemContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If mediaUrl has changed, reinitialize the video
    if (widget.isVideo && (oldWidget.mediaUrl != widget.mediaUrl)) {
      _disposeVideoController();
      _initializeVideo();
    }

    // Play or pause the video based on the active state
    if (widget.isVideo && widget.isActive) {
      _videoController?.play();
    } else if (widget.isVideo && !widget.isActive) {
      _videoController?.pause();
    }
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  void _disposeVideoController() {
    _videoController?.dispose();
    _videoController = null;
    _chewieController?.dispose();
    _chewieController = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isVideo && _isVideoInitialized) {
          setState(() {
            if (_videoController!.value.isPlaying) {
              _videoController?.pause();
            } else {
              _videoController?.play();
            }
          });
        }
      },
      child: CommonWidgets.CustomNeumorphism(
        padding: EdgeInsets.all(8.dg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isVideo && widget.isActive
                ? _buildVideoPlayer()
                : _buildImage(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: SizedBox(
          height: 270.h,
          child: Chewie(
            controller: _chewieController!,
          ),
        ),
      );
    } else {
      return SizedBox(
          height: 270.h, child: const Center(child: Loadingscreen()));
    }
  }

  Widget _buildImage() {
    return Material(
      borderRadius: BorderRadius.circular(20.r),
      elevation: 20,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: 270.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.r),
          color: Colors.grey.shade900,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CachedNetworkImage(
                height: 300.h,
                width: MediaQuery.of(context).size.width,
                imageUrl: widget.thumbnailUrl,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              widget.isVideo
                  ? Positioned(
                bottom: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    formatDuration(_videoController?.value.duration ??
                        const Duration()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
              Positioned(
                top: 0.h,
                left: 0.w,
                child: Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppConstants.filmoxLogo),
                      opacity: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final DateTime dateTime = widget.currentContest.createdDate;
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    final int daysAgo = difference.inDays;
    final int weeksAgo = (daysAgo / 7).floor();

    String timeAgo;
    if (weeksAgo >= 1) {
      timeAgo = "$weeksAgo ${weeksAgo > 1 ? 'weeks' : 'week'} ago";
    } else {
      timeAgo = "$daysAgo ${daysAgo > 1 ? 'days' : 'day'} ago";
    }

    return Container(
      padding: EdgeInsets.all(12.dg),
      width: MediaQuery.of(context).size.width - 30.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.r),
          bottomRight: Radius.circular(60.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                elevation: 30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                color: Colors.black54.withOpacity(0.3),
                child: Container(
                  padding: EdgeInsets.all(4.dg),
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:widget.currentContest.userImage,
                    errorWidget: (context, url, error) {
                      return Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.currentContest.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.credit_card_rounded,
                        color: Colors.white,
                      ),
                      Text(widget.currentContest.contestantID),
                    ],
                  )
                ],
              ),
              const Spacer(),
              VoteWidget(
                currentContest: widget.currentContest,
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              const Icon(
                Icons.how_to_vote_rounded,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "Total Votes ${widget.currentContest.totalVotes.toString()}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              const Icon(
                Icons.timer,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                timeAgo,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              const Spacer(),
              const Icon(Icons.share, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
