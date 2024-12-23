import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rclive/rcupload/thumbnail_selector.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'rc_upload_screen.dart';


class RcEditUploadScreen extends StatefulWidget {
  final ContestEntity contest;

  const RcEditUploadScreen({Key? key, required this.contest})
      : super(key: key);

  @override
  State<RcEditUploadScreen> createState() =>
      _RcEditUploadScreenState();
}

class _RcEditUploadScreenState
    extends State<RcEditUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  File? mediaFile;

  @override
  void initState() {
    super.initState();
    final userMedia = widget.contest.userMedia;

    if (userMedia?[0].mediaType == 1 &&
        userMedia != null &&
        userMedia.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse( widget.contest.userMedia![0].media),
      )..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Tap 'Reupload' if you wish to replace or reupload the media you previously added.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade800.withOpacity(0.5),
                  Colors.blueGrey.shade800.withOpacity(0.5),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: widget.contest.mediaType == 1
                    ? _buildVideoPlayer()
                    : _buildImage(),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          _buildReuploadAndSaveButton()
        ],
      ),
    );
  }

  Widget _buildReuploadAndSaveButton() {
    return Center(
      child: InkWell(
        onTap: () {
          showCustomDialog(
            context: context,
            title: "Reupload",
            okbutton: 'Proceed',
            contentText1: "Once you proceed, this action cannot be undone.",
            onCancel: () {},
            onConfirm: () {
              showImagePicker(context, widget.contest.userMedia![0].mediaType);
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 5.w),
          height: 70.h,
          width: 300.w,
          child: buttonContestUpload(
            borderRadius: 20,
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
              margin: EdgeInsets.all(8.dg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.rotate,
                    color: Theme.of(context).colorScheme.surface,
                    size: 22.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Reupload',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return SizedBox(
        height: 300.h,
        width: double.infinity,
        child: Chewie(
          controller: _chewieController,
        ),
      );
    } else {
      return SizedBox(
          height: 300.h,
          child: const Center(child: CircularProgressIndicator()));
    }
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: UrlStrings.imageUrl + widget.contest.userMedia![0].media,
      height: 300.h,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => const Center(child: Loadingscreen()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  void showImagePicker(BuildContext context, int mediaType) {
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
              Expanded(
                child: InkWell(
                  onTap: () {
                    mediaType == 2 ? _imgFromGallery() : _videoFromGallery();
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.image,
                        size: 60.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              mediaType == 2
                  ? Expanded(
                child: InkWell(
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 60.sp,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        "Camera",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _imgFromGallery() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path)); // Crop the selected image
    }
  }

  Future<void> _videoFromGallery() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        mediaFile =
            File(pickedFile.path); // Update media file with cropped image
      });
      final provider = Provider.of<RcUploadProvider>(context,
          listen: false);
      provider.selectMediaFile( mediaFile!);
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ThumbnailSelector(
                currentContest: widget.contest,
                media: mediaFile ?? File(''),
                fromEditScreen: true,
              )));
    }
  }

  void _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
          cropFrameColor: Theme.of(context).colorScheme.primary,
          statusBarColor: Theme.of(context).colorScheme.primary,
          activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
          aspectRatioPresets: Platform.isAndroid
              ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
              : [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3
          ],
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).colorScheme.surface,
          toolbarWidgetColor: Theme.of(context).colorScheme.onSurface,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3
          ],
        )
      ],
    );
    if (croppedFile != null) {
      setState(() {
        mediaFile =
            File(croppedFile.path); // Update media file with cropped image
      });
      final provider = Provider.of<RcUploadProvider>(context);

      provider.selectThumbnailFile (mediaFile!);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              RcUploadScreen(
                contest: widget.contest,
                fromEditScreen: true,
              ),
        ),
      );// Navigate to the upload screen with the selected media file
    }
  }

  void _imgFromCamera() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path)); // Crop the selected image
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