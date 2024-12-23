import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/rounds/rc_round_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entity/contest/rounds/rounds_entity.dart';



class RoundInfoScreen extends StatefulWidget {
  final RoundsEntity round;
  final String uploadType;
  final List<RoundsEntity> allRound;

  const RoundInfoScreen(
      {super.key,
        required this.round,
        required this.allRound,
        required this.uploadType});

  @override
  _RoundInfoScreenState createState() => _RoundInfoScreenState();
}

class _RoundInfoScreenState extends State<RoundInfoScreen> {
  late RoundsEntity selectedRound;
  final ImagePicker _picker = ImagePicker();
  File? mediaFile; // File to hold selected media
  @override
  void initState() {
    super.initState();
    selectedRound = widget.round;
    _startCountdown();
  }

  String timeRemaining(DateTime targetDate) {
    DateTime now = DateTime.now();
    Duration difference = targetDate.difference(now);

    if (difference.isNegative) {
      return "This round is over";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours remaining";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes remaining";
    } else {
      return "Less than a minute remaining";
    }
  }

  void _onRoundTapped(RoundsEntity round) {
    setState(() {
      selectedRound = round;
      _countdownTimer.cancel();
    });

    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(UrlStrings.imageUrl + selectedRound.poster),
                fit: BoxFit.cover,
                opacity: 0.2)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text("Other Rounds",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 26.sp)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allRound.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final otherRound = widget.allRound[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: EdgeInsets.all(8.dg),
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: otherRound.isActive
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.blue.withOpacity(0.4),
                              border: Border.all(
                                  width: 3,
                                  color: selectedRound == otherRound
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent)),
                          child: ListTile(
                            enableFeedback: true,
                            splashColor: Colors.transparent,
                            onTap: () => _onRoundTapped(otherRound),
                            // Update round when tapped
                            title: Text(otherRound.title,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                              timeRemaining(otherRound.voteDate),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: CachedNetworkImage(
                                  width: 50,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                  UrlStrings.imageUrl + otherRound.poster),
                            ),
                            trailing: Container(
                                margin: const EdgeInsets.only(right: 20),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: otherRound.isActive
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.blue.withOpacity(0.5)),
                                child: Icon(
                                  Icons.circle,
                                  color: otherRound.isActive
                                      ? Colors.green
                                      : Colors.blue,
                                  size: 10.sp,
                                )),
                          ),
                        );
                      },
                    ),
                    Text("Description",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 26.sp)),
                    const SizedBox(height: 8),
                    Text(selectedRound.roundDescription,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[700]),
                    _buildGuestList(context),
                  ],
                ),
              ),
              _buildBottomNavbar(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomNavbar(context) {
    return selectedRound.isActive && selectedRound.userMedia.media ==null
        ? CommonWidgets.CustomGlassButton(
      buttonHeight: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Edit Your Uploaded Media",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          _countdownText == ''
              ? const SizedBox.shrink()
              : Text(
            _countdownText,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(0.5)),
          ),
        ],
      ),
      onTap: () {
        // Navigator.push(context,
        //     CupertinoPageRoute(builder: (context) => RegularContestEditUploadScreen(
        //       round: widget.round,
        //     )));
      },
      context: context,
      buttonText: '',
    )
        : selectedRound.isActive && selectedRound.userMedia.media ==  null
        ? CommonWidgets.CustomGlassButton(
      buttonHeight: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Upload Media",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          _countdownText == ''
              ? const SizedBox.shrink()
              : Text(
            _countdownText,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withOpacity(0.5)),
          ),
        ],
      ),
      onTap: () {
        showImagePicker(context, widget.uploadType);
      },
      context: context,
      buttonText: '',
    )
        : const SizedBox.shrink();
  }

  Widget _buildGuestList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Guests",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 26.sp,)),
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
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Guest guest = Guest(
                  name: "Bobby Deol",
                  image:
                  'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRECoj4Z_A5iT-11NlrtzHyO1sW5CdDUNRAcEeY7RAK8SwMwhRE');
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 120.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(guest.image),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    guest.name,
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

  void showImagePicker(BuildContext context, String mediaType) {
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
                    mediaType == '2' ? _imgFromGallery() : _videoFromGallery();
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
      final provider =
      Provider.of<RcRoundUploadProvider>(context, listen: false);
      provider.setselectedFile = mediaFile!;
      // Navigator.push(
      //     context,
      //     CupertinoPageRoute(
      //         builder: (context) => ThumbnailSelectorRounds(
      //           media: File(pickedFile.path),
      //           Round: widget.round,
      //         )));
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
      final provider =
      Provider.of<RcRoundUploadProvider>(context, listen: false);
      provider.setselectedFile = mediaFile!;
      provider.setthumbnailFile = mediaFile!;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RcRoundsUploadScreen(
      //       round: widget.round,
      //       fromEdit: false,
      //     ),
      //   ),
      // ); // Navigate to the upload screen with the selected media file
    }
  }

  late Timer _countdownTimer;
  String _countdownText = "";

  void _startCountdown() {
    final voteDateTime = selectedRound.voteDate;

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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.surface),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedRound.isActive
                      ? Colors.green.withOpacity(0.4)
                      : Colors.blue.withOpacity(0.4)),
              child: Icon(
                Icons.circle,
                color: selectedRound.isActive ? Colors.green : Colors.blue,
                size: 10.sp,
              )),
          SizedBox(
            width: 5.w,
          ),
          Text(selectedRound.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 25.sp)),
        ],
      ),
    );
  }
}

class Guest {
  final String name;
  final String image;

  Guest({required this.name, required this.image});
}
