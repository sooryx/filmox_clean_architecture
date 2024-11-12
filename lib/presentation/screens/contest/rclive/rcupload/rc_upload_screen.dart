import 'dart:io';
import 'dart:math';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/contest_entity.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rclive/rcupload/components/rc_upload_header_section.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rc_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:lottie/lottie.dart';
import 'package:myself/myself.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';

import 'components/rc_custom_upload_button.dart';
import 'thumbnail_selector.dart';

class MediaUploadWidget extends StatefulWidget {
  final ContestEntity contest;
  final Function(File? mediaFile)? onMediaSelected;
  final Function? onReupload;
  final bool isNewUpload;

  const MediaUploadWidget({
    super.key,
    required this.contest,
    this.onMediaSelected,
    this.onReupload,
    required this.isNewUpload,
  });

  @override
  State<MediaUploadWidget> createState() => _MediaUploadWidgetState();
}

class _MediaUploadWidgetState extends State<MediaUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  bool _mediaInitialized = false; // Flag to prevent reinitialization
  File? mediaFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_mediaInitialized) {
      _initializeMedia();
      _mediaInitialized = true;
    }
  }

  void _initializeMedia() {
    final provider = Provider.of<RcMainProvider>(context, listen: false);
    final userMedia = widget.contest.userMedia;

    if (widget.isNewUpload ==  false) {
      print(userMedia?[0].media);
      if (userMedia != null &&
          userMedia.isNotEmpty &&
          userMedia[0].mediaType == 1) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(userMedia[0].media))
              ..initialize().then((_) {
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
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.contest.banners ?? [];
    final banner1 = banners.isNotEmpty ? banners[0] : null;
    final banner2 = banners.length > 1 ? banners[1] : null;

    final String bannerImage = (banner1?.bpId == 2
            ? banner1?.banner
            : banner2?.bpId == 2
                ? banner2?.banner
                : UrlStrings.constantImageLogo) ??
        UrlStrings.constantImageLogo;

    DateTime voteStartTime = widget.contest.voteDate;
    Duration countdownDuration = voteStartTime.difference(DateTime.now());
    MySelfColor().printSuccess(text: countdownDuration.toString());
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
        body: ListView(
          children: [
            widget.isNewUpload
                ? HeaderSection(contest: widget.contest)
                : _buildReuploadWidget(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              padding: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(colors: [
                  Colors.blueGrey.shade800.withOpacity(0.5),
                  Colors.blueGrey.shade800.withOpacity(0.5),
                ]),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: _buildMegaAuditionButton(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CommonWidgets.CustomNeumorphicTimer(
                          context: context,
                          duration: countdownDuration,
                          isHour: true),
                      CommonWidgets.CustomNeumorphicTimer(
                          context: context,
                          duration: countdownDuration,
                          isHour: true),
                      CommonWidgets.CustomNeumorphicTimer(
                          context: context,
                          duration: countdownDuration,
                          isHour: true),
                      CommonWidgets.CustomNeumorphicTimer(
                          context: context,
                          duration: countdownDuration,
                          isHour: true),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    height: 220.h,
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        child: CachedNetworkImage(
                            fit: BoxFit.fill, imageUrl: bannerImage)),
                  ),
                ],
              ),
            ),
          ],
        ));
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
              _showImagePicker(widget.contest.userMedia![0].mediaType);
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 5.w),
          height: 70.h,
          width: 300.w,
          child: RCCustomUploadButton(
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

  Widget _buildMediaPreview() {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child:
            widget.contest.mediaType == 1 ? _buildVideoPlayer() : _buildImage(),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isVideoInitialized) {
      return SizedBox(
        height: 300.h,
        width: double.infinity,
        child: Chewie(controller: _chewieController),
      );
    } else {
      return SizedBox(
        height: 300.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: UrlStrings.imageUrl + widget.contest.userMedia![0].media,
      height: 300.h,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildMegaAuditionButton(context) {
    return InkWell(
      onTap: () {
        CommonWidgets.CustomBottomSheetComments(
            context, widget.contest.megaAuditionDesc);
      },
      child: RCCustomUploadButton(
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
          height: 70.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1CB5E0).withOpacity(0.05),
                const Color(0xFF1CB5E0).withOpacity(0.01),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mega Audition',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
              Transform.rotate(
                angle: -pi / 2,
                child: Lottie.asset(
                  AppConstants.nextAnimation,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker(int mediaType) {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (builder) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImagePickerOption(
              icon: Icons.image,
              label: 'Gallery',
              onTap: () {
                mediaType == 2
                    ? _pickImageFromGallery()
                    : _pickVideoFromGallery();
              },
            ),
            if (mediaType == 2)
              _buildImagePickerOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: _pickImageFromCamera,
              ),
          ],
        );
      },
    );
  }

  Widget _buildImagePickerOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
          Navigator.pop(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60.0, color: Colors.white),
            const SizedBox(height: 12.0),
            Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) _cropImage(File(pickedFile.path));
  }

  Future<void> _pickVideoFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        mediaFile = File(pickedFile.path);
      });
      final provider = Provider.of<RcUploadProvider>(context,
          listen: false);
      provider.selectMediaFile(mediaFile ?? File(''));
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ThumbnailSelectorScreen(
            media: mediaFile!,
            currentContest: widget.contest,
          ),
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) _cropImage(File(pickedFile.path));
  }

  Future<void> _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      uiSettings: [
        AndroidUiSettings(
          cropFrameColor: Colors.blueAccent,
          statusBarColor: Colors.blueAccent,
          toolbarColor: Colors.blueAccent,
        ),
        IOSUiSettings(minimumAspectRatio: 1.0),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        mediaFile = File(croppedFile.path);
      });
      widget.onMediaSelected?.call(mediaFile);
    }
  }

  _buildReuploadWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Tap 'Reupload' if you wish to replace or reupload the media you previously added.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30.h),
        _buildMediaPreview(),
        SizedBox(height: 20.h),
        _buildReuploadAndSaveButton(),
      ],
    );
  }
}
