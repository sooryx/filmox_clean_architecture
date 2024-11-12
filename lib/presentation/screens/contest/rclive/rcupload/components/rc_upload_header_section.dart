import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/contest_entity.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'rc_custom_upload_button.dart';

class HeaderSection extends StatefulWidget {
final ContestEntity? contest;
bool? fromEditScreen;

HeaderSection({super.key, required this.contest, this.fromEditScreen});

@override
State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

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
      child: Consumer<RcUploadProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              provider.mediaFile == null
                  ? _buildNoMedia()
                  : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: widget.contest?.mediaType == 1
                      ? SizedBox(
                    height: 300.h,
                    width: double.infinity,
                    child: provider.saveContestStatus == ContestUploadStatus.loading
                        ? Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Loadingscreen(),
                          SizedBox(
                            height: 20.h,
                          ),
                          const Text(
                              'Wait while we upload your video...')
                        ],
                      ),
                    )
                        : FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return Chewie(
                            controller: ChewieController(
                              videoPlayerController:
                              _controller,
                              autoPlay: true,
                              looping: true,
                            ),
                          );
                        } else {
                          return const Center(
                            child:
                            CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                      : Image.file(
                    provider.mediaFile!,
                    height: 300.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildReuploadAndSaveButton(showFilePicker: showFilePicker),
              SizedBox(height: 20.h),
            ],
          );
        },
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
              child: InkWell(
                onTap: () async {
                  if (provider.thumbnail == null) {
                    provider.selectThumbnailFile(provider.mediaFile!);
                  }
                  if (provider.mediaFile != null) {
                    if (widget.fromEditScreen == true) {
                      try {
                        await provider.editContest(
                          id: widget.contest!.contestID,
                        );
                      } catch (e) {
                        customErrorToast(context, "Error:$e");
                      }
                    } else {
                      try {
                        await provider.saveContest(
                          id: widget.contest!.contestID,
                        );
                        await customSuccessToast(
                            context, "Contest saved successfully !");
                      } catch (e) {
                        customErrorToast(context, "Error:${provider.errorMessage}");
                      }
                    }
                  } else {
                    customErrorToast(context, "Add a file");
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5.w, right: 10.w),
                  child: RCCustomUploadButton(
                    borderRadius: 15,
                    strokeWidth: 2,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF003780),
                        Color(0xFF003780),
                        Color(0xFF1CB5E0),
                        Color(0xFF1CB5E0),
                        Color(0xFF003780),
                        Color(0xFF003780),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF003780).withOpacity(0.3),
                            const Color(0xFF1CB5E0).withOpacity(0.3),
                            const Color(0xFF1CB5E0).withOpacity(0.3),
                            const Color(0xFF003780).withOpacity(0.3),
                          ],
                        ),
                        border:
                        Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            Icons.save,
                            color: Theme.of(context).colorScheme.surface,
                            size: 25.sp,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Save',
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
      provider.selectMediaFile(File(pickedFile.path));
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
      provider.selectMediaFile(File(pickedFile.path));
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