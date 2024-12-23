// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_save_button.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HeaderSection extends StatefulWidget {
  final ContestEntity? contest;
  bool? fromEditScreen;
  final void Function() onSaveTapped;

  HeaderSection({
    super.key,
    required this.contest,
    this.fromEditScreen,
    required this.onSaveTapped,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RcUploadProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Colors.black54.withOpacity(0.5),
          padding: EdgeInsets.all(16.dg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                provider.mediaFile == null
                    ? _buildNoMedia()
                    : _buildMediaDisplay(provider),

                SizedBox(height: 20.h),
                _buildReuploadAndSaveButton(showFilePicker: showFilePicker),
                SizedBox(height: 20.h),
                _buildDisclaimers(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaDisplay(RcUploadProvider provider) {
    return Container(
      padding: EdgeInsets.all(10.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: widget.contest?.mediaType == 1
              ? _buildVideoPlayer(provider)
              : _buildImageDisplay(provider),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(RcUploadProvider provider) {
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: provider.saveContestStatus == ContestUploadStatus.loading
          ? _buildLoadingWidget('Uploading your video...')
          : FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Chewie(
              controller: ChewieController(
                videoPlayerController: _controller,
                autoPlay: true,
                looping: true,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildImageDisplay(RcUploadProvider provider) {
    return Image.file(
      provider.mediaFile!,
      height: 300.h,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoadingWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Loadingscreen(),
          SizedBox(height: 20.h),
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDisclaimers() {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),

        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructions:",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          const Text(
            "- For videos: Only MP4 format is supported. Maximum duration: 2 minutes.",
            style: TextStyle(color: Colors.white),
          ),
          const Text(
            "- For images: Only JPG, PNG formats are supported. Maximum size: 5MB.",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Text(
            "Disclaimer:",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "Ensure your content adheres to our guidelines. Inappropriate submissions will be rejected.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMedia() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: DottedBorderPainterWidget(
        roundedCorners: true,
        dashLength: 8.w,
        gapLength: 4.w,
        borderRadius: 15.r,
        strokeWidth: 2,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1CB5E0),
            Color(0xFF003780),
            Color(0xFF1CB5E0),
            Color(0xFF003780),
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: const Center(
            child: Text(
              'Please upload media',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReuploadAndSaveButton(
      {required void Function(BuildContext) showFilePicker}) {
    return Consumer<RcUploadProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showFilePicker(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.w, right: 5.w),
                  child: buttonContestUpload(
                    borderRadius: 15,
                    strokeWidth: 2,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1CB5E0),
                        Color(0xFF003780),
                        Color(0xFF1CB5E0),
                        Color(0xFF003780),
                        Color(0xFF1CB5E0),
                        Color(0xFF003780),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Theme.of(context).colorScheme.surface,
                            size: 25.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Reupload',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: CommonSaveButton(
                label: "Save",
                icon: Icons.save_alt_rounded,
                onPressed: () async {
                  widget.onSaveTapped();
                },
              ),
            )
          ],
        );
      },
    );
  }

  void showFilePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (builder) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4.8,
          margin: const EdgeInsets.only(top: 50.0),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.contest?.mediaType == 1)
                Expanded(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2.0,
                            ),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.video,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pick Video",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      pickVideo();
                    },
                  ),
                ),
              if (widget.contest?.mediaType == 2)
                Expanded(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2.0,
                            ),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.image,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Pick Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickVideo() async {
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);
    final pickedFile =
    await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      provider.selectMediaFile ( File(pickedFile.path));
      _controller = VideoPlayerController.file(provider.mediaFile!);
      _initializeVideoPlayerFuture = _controller.initialize();
      setState(() {});
    }
  }

  Future<void> pickImage() async {
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      provider.selectMediaFile ( File(pickedFile.path));
      setState(() {});
    }
  }

  void getData() async {
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);

    if (provider.mediaFile != null && widget.contest?.mediaType == 1) {
      _controller = VideoPlayerController.file(provider.mediaFile!);
      _controller.setLooping(true);
      _initializeVideoPlayerFuture = _controller.initialize();
    }
  }
}

class buttonContestUpload extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;

  const buttonContestUpload(
      {super.key,
        required this.child,
        this.strokeWidth = 2.0,
        required this.gradient,
        this.customShape,
        this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundedRectangleBorderPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        customShape: customShape,
        borderRadius: borderRadius,
      ),
      child: ClipPath(
        clipper: _RoundedRectangleBorderClipper(
          customShape: customShape,
          strokeWidth: strokeWidth,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _RoundedRectangleBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final Path? customShape;
  final double? borderRadius;

  _RoundedRectangleBorderPainter(
      {required this.strokeWidth,
        required this.gradient,
        this.customShape,
        this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = customShape ?? getDefaultShape(size);
    canvas.drawPath(path, paint);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16.0);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundedRectangleBorderClipper extends CustomClipper<Path> {
  final double strokeWidth;
  final Path? customShape;
  final double? borderRadius;

  _RoundedRectangleBorderClipper(
      {required this.strokeWidth, this.customShape, this.borderRadius});

  @override
  Path getClip(Size size) {
    return customShape ?? getDefaultShape(size);
  }

  Path getDefaultShape(Size size) {
    final rect = Offset.zero & size;
    final borderRadiusValue = BorderRadius.circular(borderRadius ?? 16);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, borderRadiusValue.topLeft));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
