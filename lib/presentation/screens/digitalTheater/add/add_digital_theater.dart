import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/multiplefileupload/multiple_file_upload_main.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/add/singlefileupload/single_file_upload_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'trailerbooster/trailer_booster.dart';

class AddDigitalTheater extends StatefulWidget {
  const AddDigitalTheater({super.key});

  @override
  _AddDigitalTheaterState createState() => _AddDigitalTheaterState();
}

class _AddDigitalTheaterState extends State<AddDigitalTheater> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Row(
              children: [
                _buildBackButton(context),
                _buildHeader(),
              ],
            ),
            SizedBox(height: 30.h),
            _buildOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Theme.of(context).colorScheme.surface,
        size: 35.sp,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(
              ["Upload ", "Your"], Theme.of(context).colorScheme.primary),
          _buildRichText(["Flicks ", "& Series."], Colors.white),
          SizedBox(height: 10.h),
          Text(
            "Select an option below to proceed.",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(List<String> texts, Color primaryColor) {
    return RichText(
      text: TextSpan(
        children: texts.map((text) {
          final isPrimary = text == texts.first || text == texts.last;
          return TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.sp,
              color: isPrimary ? primaryColor : Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) => _buildOption(context, index)),
    );
  }

  Widget _buildOption(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onOptionTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 250.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(12.dg),
        decoration: _buildBoxDecoration(index),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == index
              ? _buildSelectedOption(context, index)
              : _buildOptionContent(context, index),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(int index) {
    return BoxDecoration(
      color: const Color(0xFF2C2C2C),
      borderRadius: BorderRadius.circular(15.r),
      border: Border.all(
        color: _selectedIndex == index ? Colors.blue : Colors.transparent,
        width: 3.w,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          offset: const Offset(6, 6),
          blurRadius: 16,
          spreadRadius: 1,
        ),
        if (_selectedIndex == index)
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.6),
            offset: const Offset(0, 0),
            blurRadius: 16,
            spreadRadius: 5,
          ),
      ],
    );
  }

  Widget _buildSelectedOption(BuildContext context, int index) {
    return Row(
      key: const ValueKey<int>(0),
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          List.generate(2, (newIndex) => _buildInnerOption(context, newIndex)),
    );
  }

  Widget _buildInnerOption(BuildContext context, int newIndex) {
    return Container(
      height: 200.h,
      width: 150.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(12.dg),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 16,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(-6, -6),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onInnerOptionTap(newIndex),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                newIndex == 0 ? "Movies" : "Series",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                newIndex == 0
                    ? "Contribute Your Must-Watch Films and Cinematic Treasures"
                    : "Share Your Engaging Stories and Trending Series",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionContent(BuildContext context, int index) {
    return Row(
      children: [
        _buildOptionImage(index),
        SizedBox(width: 20.w),
        Expanded(child: _buildOptionDescription(context, index)),
      ],
    );
  }

  Widget _buildOptionImage(int index) {
    return FutureBuilder(
      future: precacheImage(
        AssetImage(index == 0
            ? AppConstants.digiTheaterMultiple
            : AppConstants.digiTheaterTrailer),
        context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Image is loaded, show the image
          return Container(
            width: 140.w,
            height: 140.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  index == 0
                      ? AppConstants.digiTheaterMultiple
                      : AppConstants.digiTheaterTrailer,
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          // Image is still loading, show CircularProgressIndicator
          return Container(
            width: 140.w,
            height: 140.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors
                  .grey[300], // Optional: a background color while loading
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildOptionDescription(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index == 0 ? 'Uploads' : 'Trailer Booster',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 5.h),
        Text(
          index == 0
              ? 'Effortlessly upload your movies—choose between a quick drop or a detailed setup to suit your needs.'
              : 'Supercharge your movie with a killer trailer drop!',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  void _onOptionTap(int index) {
    setState(() {
      HapticFeedback.selectionClick();
      _selectedIndex = _selectedIndex == index ? null : index;
      if (_selectedIndex == 1) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_selectedIndex == 1) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const Trailerbooster()));
            });
          }
        });
      }
    });
  }

  void _onInnerOptionTap(int newIndex) {
    HapticFeedback.selectionClick();
    if (newIndex == 0) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const SingleFileUploadMainScreen()));
    } else if (newIndex == 1) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const MultipleFileUploadMainScreen()));
    }
  }
}
