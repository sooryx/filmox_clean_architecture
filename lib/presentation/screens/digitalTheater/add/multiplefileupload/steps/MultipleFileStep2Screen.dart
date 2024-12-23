// ignore_for_file: unused_field

import 'dart:io';

import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_2_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MultipleFileStep2Screen extends StatefulWidget {
  const MultipleFileStep2Screen({super.key});

  @override
  _MultipleFileStep2ScreenState createState() => _MultipleFileStep2ScreenState();
}

class _MultipleFileStep2ScreenState extends State<MultipleFileStep2Screen> with SingleTickerProviderStateMixin {
  Uint8List? thumbnailDataTrailer;

  @override
  void initState() {
    super.initState();
 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   // loadingController = AnimationController(
   //   vsync: this,
   //   duration: const Duration(seconds: 4),
   // )..addListener(() {
   //   setState(() {});
   // });
 },);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.dg),
      child: Consumer<MultipleFileUploadStep2Provider>(
        builder: (context, stepProvider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeading("Upload the Poster for Your Series"),
              SizedBox(
                height: 10.h,
              ),
              _buildDescription(
                  "This poster will be used as the thumbnail for the uploaded movie"),
              SizedBox(height: 10.h),
              _buildUploadPhoto(),
              SizedBox(height: 20.h),
              _buildRadioSelection(
                title: "Choose your trailer file type",
                description:
                "Choose between two options for trailer files: either upload a file or provide a URL link.",
                onChanged: (value) {
                  stepProvider.settrailerType = value;
                },
                selectedValue: stepProvider.trailerType,
                options: const ["Url", "File"],
              ),
              SizedBox(height: 20.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: stepProvider.trailerType == "File"
                    ? _uploadVideoTrailer()
                    : stepProvider.trailerType == "Url"
                    ? _buildTextField(
                    controller: stepProvider.trailerLink,
                    hintText: 'Trailer Url')
                    : Container(), // Empty container when no option is selected
              ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );

  }
  Widget _buildHeading(String heading) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(fontSize: 14.sp),
    );
  }

  Future<void> _pickPoster() async {
    final provider = Provider.of<MultipleFileUploadStep2Provider>(context,listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        provider.poster = File(pickedFile.path);
        provider.setposterFile = provider.poster!;

      }
    });
  }

  Widget _buildUploadPhoto() {
    final provider = Provider.of<MultipleFileUploadStep2Provider>(context,listen: false);

    return GestureDetector(
      onTap: _pickPoster,
      child: Container(
        height: 160.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: provider.poster != null ? BoxFit.cover : BoxFit.contain,
            image:provider.poster != null
                ? FileImage(provider.poster!) as ImageProvider<Object>
                : AssetImage(AppConstants.uploadIcon),
          ),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _uploadVideoTrailer() {
    final stepProvider =
    Provider.of<MultipleFileUploadStep2Provider>(context, listen: false);
    return InkWell(
      onTap: () {
        pickTrailerVideoFile().then((value) {
          if (stepProvider.pickedFile != null) {
            generateThumbnailTrailer(stepProvider.pickedFile!.path);
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
                  const Text("Proceed to upload the trailer"),
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
                      "Choose the trailer video file ",
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
    Provider.of<MultipleFileUploadStep2Provider>(context, listen: false);

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
                thumbnailDataTrailer == null
                    ? SizedBox(
                    height: 30.w,
                    width: 30.w,
                    child: const CircularProgressIndicator())
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.memory(thumbnailDataTrailer!, width: 70.w),
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
                                  stepProvider.setpickedFile = File('');
                                  thumbnailDataTrailer = null;
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
                      // Container(
                      //   height: loadingController.value == 1.0 ? 20.h : 5.h,
                      //   clipBehavior: Clip.hardEdge,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5.r),
                      //     color: loadingController.value == 1.0
                      //         ? Colors.transparent
                      //         : Colors.blue.shade50,
                      //   ),
                      //   child: loadingController.value == 1.0
                      //       ? Row(
                      //     children: [
                      //       Lottie.asset(
                      //           "assets/animations/success.json"),
                      //       SizedBox(width: 4.w),
                      //       Expanded(
                      //         child: Text(
                      //           "Proceed to upload to server ",
                      //           style: TextStyle(
                      //               color: Colors.green, fontSize: 12.sp),
                      //         ).animate().shimmer(),
                      //       ),
                      //     ],
                      //   )
                      //       : LinearProgressIndicator(
                      //       value: loadingController.value),
                      // ),
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
  String showYear = 'Select Year';
  final DateTime _selectedYear = DateTime.now();

  Future<void> pickTrailerVideoFile() async {
    final stepProvider =
    Provider.of<MultipleFileUploadStep2Provider>(context, listen: false);

    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      stepProvider.setpickedFile = File(xFile.path);
    }
    // loadingController.forward();
  }

  Future<void> generateThumbnailTrailer(String videoPath) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      thumbnailDataTrailer = thumbnail;
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
