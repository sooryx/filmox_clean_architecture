import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/traler_booster/trailer_booster_provider.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Trailerbooster extends StatefulWidget {
  const Trailerbooster({super.key});

  @override
  _TrailerboosterState createState() => _TrailerboosterState();
}

class _TrailerboosterState extends State<Trailerbooster>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  String _filePath = '';

  late TextEditingController _titleController;
  final FocusNode _titleControllerFocusNode = FocusNode();
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      customErrorToast(context, e.toString());
    }
  }

  Widget _buildLinearProgressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 12.h,
            width: 250.w,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              tween: Tween<double>(
                begin: 0,
                end: (_currentPage + 1) / 4,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                borderRadius: BorderRadius.circular(20.r),
                backgroundColor: Colors.grey,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text("${_currentPage.toString()}/3")
        ],
      ),
    );
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
            title: Hero(
              tag: 'trailerbooster',
              child: Text(
                "Trailer Booster",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: _buildLinearProgressIndicator())),
        body: Consumer<TrailerBoosterProvider>(
          builder: (context, trailerProvider, child) {
            return GestureDetector(
              onTap: () {
                _titleControllerFocusNode.unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.dg),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildTitleInputPage(),
                        _buildPosterUploadPage(),
                        _buildFileUploadPage(
                          pickVideo: () async {
                            await _pickVideo();
                          },
                        ),
                        _buildReviewPage(title: trailerProvider.title),
                      ],
                    ),
                  ),
                  _currentPage == 3
                      ? const SizedBox.shrink()
                      : _buildheader(title: _titleController.text),
                  _buildbottomButton(
                    isLoading:

                            trailerProvider.staus == DefaultPageStatus.loading,
                    trailerProvider: trailerProvider,
                    onFinaltap: () async {
                      trailerProvider.settitle = _titleController.text;
                      trailerProvider.setposterFile = _selectedImage!;
                      trailerProvider.setvideoFile = _videoFile!;

                      try {
                        await trailerProvider.saveTrailerBooster();
                        customSuccessToast(
                            context, "Trailer added successfully");
                        Navigator.pop(context);
                      } catch (e) {
                        customErrorToast(context, e.toString());
                      }
                    },
                  )
                ],
              ),
            );
          },
        ));
  }

  // Widget _buildCategorySelectionPage() {
  //   return Consumer<Digitaltheaterdashboardprovider>(
  //     builder: (context, provider, child) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             height: 100.h,
  //           ),
  //           Text(
  //             "Choose a category from the following",
  //             style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 26.sp),
  //           ),
  //           SizedBox(height: 20.h),
  //           Text(
  //             "Select the category that best fits your movie. From action-packed adventures to heartwarming dramas, pick the genre that defines your creation.",
  //             style: Theme.of(context).textTheme.bodyMedium,
  //           ),
  //           SizedBox(height: 20.h),
  //           Wrap(
  //             spacing: 10.w,
  //             runSpacing: 10.h,
  //             children: List.generate(
  //                 provider.fetchCategory?.data.categories.length ?? 0, (index) {
  //               final double width = 80 + (index % 3) * 40.0;
  //               final double height = 80 + (index % 3) * 40.0;
  //               final double scatterAmount = 20.0;
  //               final isSelected = _selectedCategory ==
  //                   provider.fetchCategory?.data.categories[index].category;
  //
  //               return GestureDetector(
  //                 onTap: () => _updateCategory(
  //                     provider.fetchCategory?.data.categories[index].category ??
  //                         ""),
  //                 child: AnimatedBuilder(
  //                   animation: _animationController,
  //                   child: AnimatedContainer(
  //                     duration: const Duration(milliseconds: 300),
  //                     margin: const EdgeInsets.symmetric(vertical: 20),
  //                     width: width,
  //                     height: height,
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFF2C2C2C),
  //                       shape: BoxShape.circle,
  //                       border: isSelected
  //                           ? Border.all(color: Colors.blue, width: 5.0)
  //                           : null,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.6),
  //                           offset: const Offset(4, 4),
  //                           blurRadius: 10,
  //                           spreadRadius: 1,
  //                         ),
  //                         BoxShadow(
  //                           color: Colors.white.withOpacity(0.1),
  //                           offset: const Offset(-4, -4),
  //                           blurRadius: 10,
  //                           spreadRadius: 1,
  //                         ),
  //                       ],
  //                     ),
  //                     child: Center(
  //                       child: isSelected
  //                           ? Icon(
  //                         Icons.check,
  //                         color: Colors.blue,
  //                         size: 40,
  //                       )
  //                           : Text(
  //                         provider.fetchCategory?.data.categories[index]
  //                             .category ??
  //                             "",
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .bodyLarge
  //                             ?.copyWith(fontSize: 18.sp),
  //                       ),
  //                     ),
  //                   ),
  //                   builder: (context, child) {
  //                     return Transform.translate(
  //                       offset: Offset(
  //                         scatterAmount *
  //                             (index.isEven ? -1 : 1) *
  //                             _animationController.value,
  //                         scatterAmount *
  //                             (index.isOdd ? -1 : 1) *
  //                             _animationController.value,
  //                       ),
  //                       child: child,
  //                     );
  //                   },
  //                 ),
  //               );
  //             }),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildPosterUploadPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100.h),
        Text(
          "Why a Poster is Essential",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 24.sp),
        ),
        SizedBox(height: 15.h),
        Text(
          "A compelling poster captures the essence of your movie at a glance...",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 250.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor),
            ),
            child: Center(
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppConstants.uploadIcon,
                          height: 100.h,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Tap to upload',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.file(
                        _selectedImage!,
                        height: 250.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInputPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80.h,
        ),
        Text(
          "Title Your Masterpiece",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 26.sp),
        ),
        SizedBox(height: 20.h),
        Text(
          "Give your movie a captivating title that grabs attention and reflects its essence.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 20.h),
        TextField(
          controller: _titleController,
          focusNode: _titleControllerFocusNode,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
              labelText: 'Enter the title for your movie',
              labelStyle: Theme.of(context).textTheme.bodyMedium),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildFileUploadPage({required void Function()? pickVideo}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80.h),
        Text(
          "Upload Your Movie File",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 26.sp),
        ),
        SizedBox(height: 20.h),
        Text(
          "Get ready to showcase your creation—upload your video file and let your story captivate audiences!",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 60.h),
        GestureDetector(
          onTap: pickVideo,
          child: Container(
            height: 250.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor),
            ),
            child: Center(
              child: _thumbnailPath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppConstants.uploadIcon,
                          height: 100.h,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Tap to upload',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.memory(
                        _thumbnailPath!,
                        height: 250.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewPage({required String title}) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Review your submission",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 40.h),
        Container(
          padding: EdgeInsets.all(12.dg),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.r),
              border: Border.all(
                  width: 4, color: Theme.of(context).primaryColor)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Name",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: 150.w,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Video File",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: _thumbnailPath == null
                        ? const Text(
                            "No thumbnail available") // Placeholder when thumbnail is null
                        : Image.memory(
                            _thumbnailPath!,
                            height: 150.h,
                            width: 150.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Poster",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: _thumbnailPath == null
                        ? const Text(
                            "No thumbnail available") // Placeholder when thumbnail is null
                        : Image.file(
                            _selectedImage!,
                            height: 150.h,
                            width: 150.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().shimmer( duration: 800.ms)
      ],
    );
  }

  Widget _buildheader({required String title}) {
    return Positioned(
      top: 30.h,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,padding: EdgeInsets.only(left: 30),
        child: SizedBox(
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => _pageController.animateToPage(0, duration: 300.ms, curve: Curves.elasticInOut),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: title.isNotEmpty
                      ? Container(
                          key: ValueKey(title),
                          child: Column(
                            children: [
                              Text(
                                "Title",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.grey, fontSize: 14.sp),
                              ),
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () =>
                    _pageController.animateToPage(1, duration: 300.ms, curve: Curves.elasticInOut),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedImage != null
                      ? Container(
                          key: ValueKey(_selectedImage),
                          child: Column(
                            children: [
                              Text(
                                "Poster",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.grey, fontSize: 14.sp),
                              ),
                              _selectedImage == null
                                  ? const SizedBox.shrink()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: 30.w,
                                        height: 30.h,
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () =>
                    _pageController.animateToPage(2, duration: 300.ms, curve: Curves.elasticInOut),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _filePath.isNotEmpty
                      ? Container(
                          key: ValueKey(_filePath),
                          child: Column(
                            children: [
                              Text(
                                "Video File",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.grey, fontSize: 14.sp),
                              ),
                              _thumbnailPath == null
                                  ? const SizedBox.shrink()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.memory(
                                        _thumbnailPath!,
                                        height: 30.h,
                                        width: 30.w,
                                        fit: BoxFit.cover,
                                      ))
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildbottomButton(
      {required void Function() onFinaltap,
      required bool isLoading,
      required TrailerBoosterProvider trailerProvider}) {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: () {
            if (_currentPage == 0) {
              // Validation for Page 1
              if (_titleController.text.isNotEmpty) {
                trailerProvider.settitle = _titleController.text;
                _nextPage();
              } else {
                HapticFeedback.heavyImpact();

                customRandomToast(context, "Enter title for your movie");
              }
            } else if (_currentPage == 1) {
              // Validation for Page 2
              if (_selectedImage != null) {
                _nextPage();
              } else {
                HapticFeedback.heavyImpact();

                customRandomToast(context, "Pick a poster");
              }
            } else if (_currentPage == 2) {
              // Validation for Page 3
              if (_filePath.isNotEmpty) {
                _nextPage();
              } else {
                HapticFeedback.heavyImpact();

                customRandomToast(context, "Upload a file");
              }
            } else if (_currentPage == 3) {
              onFinaltap();
            }
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: const Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : Icon(
                          _currentPage == 3
                              ? Icons.check
                              : Icons.arrow_forward_ios,
                          color: Colors.blue,
                          size: 35,
                        ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              _currentPage == 3
                  ? Text(isLoading ? "Please wait..." : "You are good to go !")
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

  }

  Uint8List? _thumbnailPath;
  String title = '';
  File? _videoFile;

  Future<void> _pickVideo() async {
    final result = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (result != null) {
      _videoFile = File(result.path);

      // Generate thumbnail
      final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: _videoFile!.path,
        // thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 250, // Specify the max height of the thumbnail
        quality: 75,
      );

      // Refresh the UI after picking a video and generating the thumbnail
      setState(() {
        _thumbnailPath = thumbnail;
        _filePath = _videoFile!.path;
      });
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.mediumImpact();

    if (_currentPage == 1) {
      setState(() {
        title = _titleController.text;
      });
    }

    // Update file path if on file upload page
    if (_currentPage == 2 && _filePath.isEmpty) {
      // Simulate file selection
      _filePath = 'path/to/your/file';
    }

    if (_currentPage < 3) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

// void _updateCategory(String category) {
//   setState(() {
//     _selectedCategory = category;
//   });
// }
}
