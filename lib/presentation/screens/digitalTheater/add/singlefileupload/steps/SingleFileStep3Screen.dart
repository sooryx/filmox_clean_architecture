import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_3.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class SingleFileUploadStep3Screen extends StatefulWidget {
  const SingleFileUploadStep3Screen({super.key});

  @override
  _SingleFileUploadStep3ScreenState createState() => _SingleFileUploadStep3ScreenState();
}

class _SingleFileUploadStep3ScreenState extends State<SingleFileUploadStep3Screen>
    with SingleTickerProviderStateMixin {
  Uint8List? thumbnailDataMovie;
  late AnimationController loadingController;

  @override
  void initState() {
    super.initState();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.dg),
      child: Consumer<Step3DTSFUploadProvider>(
        builder: (context, stepProvider, _) {
          print("Movie Type :${stepProvider.singleMediaType}");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioSelection(
                title: "Choose your Movie file type",
                description:
                "Choose between two options for Movie files: either upload a file or provide a URL link.",
                onChanged: (value) {
                  stepProvider.setMovietype = value;
                },
                selectedValue: stepProvider.singleMediaType,
                options: const ["Url", "File"],
              ),
              SizedBox(height: 20.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: stepProvider.singleMediaType == "File"
                    ? _uploadVideoMovie()
                    : stepProvider.singleMediaType == "Url"
                    ? _buildTextField(
                    controller: stepProvider.singleMediaLink,
                    hintText: 'Movie Url')
                    : Container(), // Empty container when no option is selected
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }

  Widget _uploadVideoMovie() {
    final stepProvider =
    Provider.of<Step3DTSFUploadProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        pickMovieVideoFile().then((value) {
          if (stepProvider.pickedFile != null) {
            generateThumbnailMovie(stepProvider.pickedFile!.path);
          }
        });
      },
      child: Center(
        child: Column(
          children: [
            if (stepProvider.pickedFile != null)
              Column(
                children: [
                  Lottie.asset(
                    AppConstants.successVideoUpload,
                    height: 250.h,
                    width: 250.w,
                    fit: BoxFit.cover,
                  ),
                  const Text("Proceed to upload the Movie"),
                  _buildFileDetails(),
                ],
              )
            else
              Container(
                height: 220.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    width: 2,
                    color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppConstants.uploadIcon,
                      height: 120.h,
                      width: 120.w,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Choose the Movie video file ",
                      style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileDetails() {
    final stepProvider =
    Provider.of<Step3DTSFUploadProvider>(context, listen: false);
if(stepProvider.pickedFile == null){
  return Center(
    child: Text(
      'No file selected',
      style: TextStyle(color: Colors.grey, fontSize: 15.sp),
    ),
  );
}else{
  return Container(
    padding: EdgeInsets.all(20.dg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selected File',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15.sp)),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(8.dg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade800.withOpacity(0.9),
                Colors.grey.shade800,
                Colors.grey.shade800.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200,
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              thumbnailDataMovie == null
                  ? SizedBox(
                  height: 30.w,
                  width: 30.w,
                  child: const CircularProgressIndicator())
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.memory(thumbnailDataMovie!, width: 70.w),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (stepProvider.pickedFile != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              stepProvider.pickedFile!.path.split('/').last,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                stepProvider.setPickedFile = null;
                                thumbnailDataMovie = null;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '${(stepProvider.pickedFile!.lengthSync() / 1024).ceil()} KB',
                        style: TextStyle(
                            fontSize: 13.sp, color: Colors.grey.shade500),
                      ),
                    ],
                    SizedBox(height: 5.h),
                    Container(
                      height: loadingController.value == 1.0 ? 20.h : 5.h,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: loadingController.value == 1.0
                            ? Colors.transparent
                            : Colors.blue.shade50,
                      ),
                      child: loadingController.value == 1.0
                          ? Row(
                        children: [
                          Lottie.asset(
                              "assets/animations/success.json"),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "Proceed to upload to server ",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 12.sp),
                            ).animate().shimmer(),
                          ),
                        ],
                      )
                          : LinearProgressIndicator(
                          value: loadingController.value),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ],
    ),
  );
}

  }

  Future<void> pickMovieVideoFile() async {
    final stepProvider =
    Provider.of<Step3DTSFUploadProvider>(context, listen: false);

    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      stepProvider.setPickedFile = File(xFile.path);
    }
    loadingController.forward();
  }

  Future<void> generateThumbnailMovie(String videoPath) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      thumbnailDataMovie = thumbnail;
    });
  }

  Widget _buildRadioSelection({
    required String title,
    required String description,
    required void Function(dynamic value) onChanged,
    required String? selectedValue,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 10.h),
        Text(description, style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 20.h),
        Column(
          children: options.map((option) {
            return RadioListTile<String>(
              value: option,
              contentPadding: const EdgeInsets.all(10),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor; // Color when selected
                }
                return Colors.grey; // Color when unselected
              }),
              shape: const RoundedRectangleBorder(),
              toggleable: true,
              dense: true,
              activeColor: Colors.red,
              groupValue: selectedValue,
              onChanged: onChanged,
              title: Text(
                option,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w300),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return CommonWidgets.CustomTextField(
        controller: controller, hintText: hintText, obscureText: false);
  }
}
