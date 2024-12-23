// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_upload_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/count_down_timer_widget.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'components/rc_upload_header_section.dart';


class RcUploadScreen extends StatefulWidget {
  ContestEntity? contest;
  bool? fromEditScreen;

  RcUploadScreen({super.key, this.contest, this.fromEditScreen});

  @override
  State<RcUploadScreen> createState() =>
      _RcUploadScreenState();
}

class _RcUploadScreenState
    extends State<RcUploadScreen> {
  final picker = ImagePicker();

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final banners = widget.contest?.banners ?? [];
    final banner1 = banners.isNotEmpty ? banners[0] : null;
    final banner2 = banners.length > 1 ? banners[1] : null;

    final String bannerImage = (banner1?.bpId == 2
        ? banner1?.banner
        : banner2?.bpId == 2
        ? banner2?.banner
        : UrlStrings.constantImageLogo) ??
        UrlStrings.constantImageLogo;

    DateTime voteStartTime = widget.contest?.voteDate ?? DateTime.now();
    Duration countdownDuration = voteStartTime.difference(DateTime.now());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Upload Media'),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.5),
            image: DecorationImage(
              image:
              NetworkImage( widget.contest!.poster),
              fit: BoxFit.cover,
              opacity: 0.8,
            )),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          children: [
            HeaderSection(
              contest: widget.contest,
              fromEditScreen: widget.fromEditScreen,
              onSaveTapped: () async => await onSaveTapped(context),
            ),
            Container(
                color: Colors.black54.withOpacity(0.5),
                child: _buildBannerSection(
                    context, bannerImage, countdownDuration)),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(
      BuildContext context, String bannerImage, Duration countdownDuration) {
    return Container(
      margin:
      EdgeInsets.only(left: 10.w, right: 10.w, top: 120.h, bottom: 40.h),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildMegaAuditionButton(context)),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: _buildCountdownRow(countdownDuration, context),
          ),
          _buildBannerImage(bannerImage),
          if (_isSaving)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: _buildLoadingIndicator(),
            )
        ],
      ),
    );
  }

  Widget _buildCountdownRow(Duration countdownDuration, BuildContext context) {
    return CountdownText(
      countdownDuration: countdownDuration,
      countdownText: '',
      fontSize: 42.sp,
    );
  }

  Widget _buildBannerImage(String bannerImage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      height: 220.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: UrlStrings.imageUrl + bannerImage,
          placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildMegaAuditionButton(BuildContext context) {
    return InkWell(
      onTap: () {
        CommonWidgets.CustomBottomSheetComments(
            context, widget.contest?.megaAuditionDesc ?? '');
      },
      child: buttonContestUpload(
        borderRadius: 15,
        strokeWidth: 2,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
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
                'Voting Starts In',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    letterSpacing: 2),
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

  bool _isSaving = false;

  double _progress = 0.0;

  String _loadingMessage = "Starting save operation...";

  late Timer _timer;

  final List<String> _loadingMessages = [
    "Initializing save operation...",
    "Processing file...",
    "Uploading data...",
    "Finalizing save...",
    "Almost done...",
  ];

  void _startLoadingIndicator() {
    int step = 0;
    setState(() {
      _isSaving = true;
      _progress = 0.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (step < _loadingMessages.length) {
        setState(() {
          _progress += 0.2; // 20% increment
          _loadingMessage = _loadingMessages[step];
        });
        step++;
      } else {
        _timer.cancel();
      }
    });
  }

  void _stopLoadingIndicator() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _isSaving = false;
      _progress = 0.0;
      _loadingMessage = "";
    });
  }

  Future<void> onSaveTapped(BuildContext context) async {
    _startLoadingIndicator();
    final provider =
    Provider.of<RcUploadProvider>(context, listen: false);
    _pageController.animateToPage(1,
        duration: 1200.ms, curve: Curves.elasticIn);
    try {
      await Future.delayed(
          const Duration(seconds: 5)); // Simulate save operation
      if (provider.mediaFile != null) {
        if (provider.thumbnail == null) {
          provider.selectThumbnailFile(provider.mediaFile!);
        }
        if (widget.fromEditScreen == true) {
          print('''
          From Edit Screen : ${widget.fromEditScreen}
          ContestID : ${widget.contest!.contestID}
          Picked File : ${provider.mediaFile}
          ''');
          await provider.editContest(id: widget.contest!.contestID);

          await customSuccessToast(context, "Contest edited successfully!");
        } else {
          print("Save");
          await provider.saveContest(id: widget.contest!.contestID);

          await customSuccessToast(context, "Contest saved successfully!");
        }
      } else {
        customErrorToast(context, "Add a file");
      }
    } catch (e) {
      customErrorToast(context, "Error: $e");
    } finally {
      _stopLoadingIndicator();
    }
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 10.h),
          Text(
            _loadingMessage,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
