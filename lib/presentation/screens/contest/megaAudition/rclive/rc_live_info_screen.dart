// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rclive/rcupload/rc_edit_upload_screen.dart';
import 'package:filmox_clean_architecture/widgets/common_save_button.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/expandable_text_widget.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'rcupload/thumbnail_selector.dart';

class RcLiveInfoScreen extends StatefulWidget {
  final ContestEntity currentItemContest;

  // Constructor with required parameters
  const RcLiveInfoScreen({
    super.key,
    required this.currentItemContest,
  });

  @override
  State<RcLiveInfoScreen> createState() => _RcLiveInfoScreenState();
}

class _RcLiveInfoScreenState extends State<RcLiveInfoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? mediaFile; // File to hold selected media
  late Timer _countdownTimer;

  String _countdownText = "";

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final voteDateTime = widget.currentItemContest.voteDate;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = voteDateTime.difference(now);

      if (difference.isNegative) {
        setState(() {
          _countdownText = "Expired";
        });
        timer.cancel();
      } else {
        final days = difference.inDays;
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;
        String countdownText = '';

        if (days > 0) countdownText += "${days}d ";
        if (hours > 0) countdownText += "${hours}h ";
        if (minutes > 0) countdownText += "${minutes}m ";
        if (seconds > 0) countdownText += "${seconds}s";
        setState(() {
          _countdownText = countdownText.trim();
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  // Widget to build section headings
  Widget _buildHeading(String heading) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = widget.currentItemContest.startDate;
    DateTime now = DateTime.now();

    bool showNavBar() {
      if (now.isBefore(startDate)) {
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: null,
      bottomNavigationBar:
          showNavBar() ? Hero(tag: 'time', child: _buildBottomNavBar()) : null,
      body: Hero(
        tag: 'bg',
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage((widget.currentItemContest.poster)),
                  fit: BoxFit.cover,
                  opacity: 0.05)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(),
                  widget.currentItemContest.banners?.isEmpty ?? true
                      ? const SizedBox.shrink()
                      : _buildBanner(),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      _buildHeading("Contest Description"),
                      Expanded(
                        child: CommonWidgets.CustomDivider(
                            start: 1, end: 1, thickness: 1, color: Colors.grey),
                      ),
                    ],
                  ),
                  widget.currentItemContest.contestDesc == null
                      ? const SizedBox.shrink()
                      : _buildContentDescription(),
                  SizedBox(height: 20.h),
                  widget.currentItemContest.guests?.isEmpty ?? true
                      ? const SizedBox.shrink()
                      : _buildGuestList(),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildAdvertisments()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    if (widget.currentItemContest.userMedia?.isNotEmpty == true) {
      return CommonSaveButton(
        label: 'Edit Your Uploaded Media',
        margin: EdgeInsets.symmetric(vertical: 20.h,horizontal: 30.w),
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => RcEditUploadScreen(
                contest:widget.currentItemContest,
              )));
        },
      ).animate().fadeIn(duration: 600.ms).scale(
        begin: const Offset(0.9, 0.9),
        end: const Offset(1.0, 1.0),
        duration: 800.ms,
        curve: Curves.easeOutBack,
      );

    } else if (widget.currentItemContest.userMedia?.isEmpty == true) {
      return _countdownText.isNotEmpty
          ?      CommonSaveButton(
        label: 'Save',
        margin: EdgeInsets.symmetric(vertical: 20.h,horizontal: 80.w),
        onPressed: () {
          showImagePicker(
            context,
            widget.currentItemContest.mediaType,
          );
        },
      ).animate().fadeIn(duration: 600.ms).scale(
        begin: const Offset(0.9, 0.9),
        end: const Offset(1.0, 1.0),
        duration: 800.ms,
        curve: Curves.easeOutBack,
      )
          : CommonWidgets.CustomGlassButton(
        buttonHeight: 65.h,
        borderColor: [
          Theme.of(context).primaryColor.withOpacity(0.8),
          Theme.of(context).primaryColor.withOpacity(0.2),
        ],
        buttonColor: [
          Theme.of(context).primaryColor.withOpacity(0.8),
          Theme.of(context).primaryColor.withOpacity(0.2),
        ],
        child:const Loadingscreen(),
        onTap: () {
          showImagePicker(
            context,
            widget.currentItemContest.mediaType,
          );
        },
        buttonText: _countdownText == ""
            ? "Audition Ends in ..."
            : "Audition Ends in $_countdownText",
        context: context,
      );
    }

    // Fallback widget if none of the conditions are met
    return const SizedBox.shrink(); // or any other default widget
  }

  // Builds the banner section with a PageView for scrolling through images
  Widget _buildBanner() {
    final banner1 = widget.currentItemContest.banners![0];
    final banner2 = widget.currentItemContest.banners![1];
    final bannerImage = banner1.bpId == 1
        ? banner1.banner
        : banner2.bpId == 1
            ? banner2.banner
            : UrlStrings.constantImageLogo;
    return SizedBox(
        height: 150.h,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 300),
            fit: BoxFit.cover,
            fadeInCurve: Curves.easeIn,
            imageUrl: (bannerImage ?? UrlStrings.constantImageLogo),
            placeholder: (context, url) => const Loadingscreen(),
            errorWidget: (context, url, error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 40.sp,
                ),
                SizedBox(height: 20.h),
                Text(
                  "No image is present in $url",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }

  // Builds the list of guests
  Widget _buildGuestList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildHeading("Guests"),
            Expanded(
              child: CommonWidgets.CustomDivider(
                  start: 1, end: 1, thickness: 1, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            itemCount: widget.currentItemContest.guests?.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              GuestEntity guest = widget.currentItemContest.guests![index];
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 120.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(guest.image != null
                              ? guest.image!
                              : UrlStrings.constantImageLogo),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    guest.name ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 16.sp),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Builds the content description section with expandable text
  Widget _buildContentDescription() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        ExpandableTextWidget(
          text: widget.currentItemContest.contestDesc,
        ),
      ],
    );
  }

  // Displays the image picker options
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

  // Handles image selection from the camera
  void _imgFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path)); // Crop the selected image
    }
  }

  // Handles image selection from the gallery
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
      final provider = Provider.of<RcUploadProvider>(context, listen: false);
      provider.selectMediaFile(mediaFile!);
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ThumbnailSelector(
                    currentContest: widget.currentItemContest,
                    media: mediaFile ?? File(''),
                  )));
    }
  }

  // Crops the selected image
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
      final provider = Provider.of<RcUploadProvider>(context, listen: false);
      provider.selectMediaFile(mediaFile!);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RegularContestUploadScreen(
      //       contest: widget.currentItemContest,
      //       fromEditScreen: false,
      //     ),
      //   ),
      // ); // Navigate to the upload screen with the selected media file
    }
  }

  _buildAdvertisments() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.grey.shade800),
      child: Center(
          child: Text(
        "Placeholder for ads",
        style: Theme.of(context).textTheme.bodyMedium,
      )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.surface),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        widget.currentItemContest.name,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
      ),
    );
  }
}
