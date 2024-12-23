// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditTrailerInfo extends StatefulWidget {
  String? dropDownTrailerType;
  String? trailer;
  String? dtId;

  EditTrailerInfo({
    required this.dropDownTrailerType,
    required this.trailer,
    this.dtId,
    super.key,
  });

  @override
  State<EditTrailerInfo> createState() => _EditTrailerInfoState();
}

class _EditTrailerInfoState extends State<EditTrailerInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController;

  late TextEditingController _trailerUrlController;

  @override
  void initState() {
    super.initState();
    _trailerUrlController = TextEditingController(text: widget.trailer);
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Edit trailer info"),
        actions: [
          IconButton(
              onPressed: () {
                showCustomDialog(
                  context: context,
                  title: "Are you sure?",
                  contentText1:
                      "Tapping okay will remove your previously uploaded trailer ",
                  onCancel: () {},
                  onConfirm: () {
                    try {
                      // SingleFileUploadRepo().UploadTrailerVideo(
                      //     context,
                      //     widget.dropDownTrailerType,
                      //     _trailerUrlController.text,
                      //     pickedTrailerFile,
                      //     widget.dtId);
                      Navigator.pop(context);
                    } catch (e) {}
                  },
                );
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.dg),
        children: [
          Text(
            "Trailer Type",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 140.w,
                child: CommonWidgets.CustomDropDown(
                    context: context,
                    hintText: 'Trailer Type',
                    items: const [
                      "link",
                      "file",
                    ],
                    selectedValue: widget.dropDownTrailerType,
                    onChanged: (value) => {
                          setState(() {
                            widget.dropDownTrailerType = value;
                          })
                        },
                    buttonWidth: 160.w,
                    buttonHeight: 60.h),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          widget.dropDownTrailerType == "file"
              ? GestureDetector(
                  child: Column(
                  children: [
                    uploadVideoTrailer(),
                    pickedTrailerFile != null
                        ? Container(
                            padding: EdgeInsets.all(20.dg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected File',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                    padding: EdgeInsets.all(8.dg),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(colors: [
                                        Colors.grey.shade800.withOpacity(0.9),
                                        Colors.grey.shade800,
                                        Colors.grey.shade800.withOpacity(0.9),
                                        Colors.grey.shade800,
                                        Colors.grey.shade800.withOpacity(0.9),
                                      ]),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.shade200,
                                          offset: const Offset(0, 1),
                                          blurRadius: 3,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        thumbnailDataTrailer == null
                                            ? SizedBox(
                                                height: 30.w,
                                                width: 30.w,
                                                child:
                                                    const CircularProgressIndicator())
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: Image.memory(
                                                  thumbnailDataTrailer!,
                                                  width: 70.w,
                                                ) // Change from _file to _imageFile
                                                ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      pickedTrailerFile!.path
                                                          .split('/')
                                                          .last,
                                                      style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pickedTrailerFile =
                                                            null;
                                                        thumbnailDataTrailer =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                '${(pickedTrailerFile!.lengthSync() / 1024).ceil()} KB',
                                                style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Container(
                                                height:
                                                    loadingController.value ==
                                                            1.0
                                                        ? 20.h
                                                        : 5.h,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color:
                                                      loadingController.value ==
                                                              1.0
                                                          ? Colors.transparent
                                                          : Colors.blue.shade50,
                                                ),
                                                child: loadingController
                                                            .value ==
                                                        1.0
                                                    ? Row(
                                                        children: [
                                                          Lottie.asset(
                                                              "assets/animations/success.json"),
                                                          SizedBox(
                                                            width: 4.w,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "Proceed to upload to server ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize:
                                                                      12.sp),
                                                            )
                                                                .animate()
                                                                .shimmer(),
                                                          ),
                                                        ],
                                                      )
                                                    : LinearProgressIndicator(
                                                        value: loadingController
                                                            .value,
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ))
                        : Container(),
                  ],
                ))
              : CommonWidgets.CustomTextField(
                  controller: _trailerUrlController,
                  borderRadius: BorderRadius.circular(20.r),
                  hintText: 'Trailer Url',
                  obscureText: false),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget uploadVideoTrailer() {
    return InkWell(
      onTap: () {
        pickTrailerVideoFile().then((value) {
          if (pickedTrailerFile != null) {
            generateThumbnailTrailer(pickedTrailerFile!.path);
          }
        });
      },
      child: Column(
        children: [
          if (pickedTrailerFile != null) // Use an if statement
            Column(
              children: [
                Lottie.asset(
                  AppConstants.successVideoUpload,
                  height: 250.h,
                  width: 250.w,
                  fit: BoxFit.cover,
                ),
                const Text("Proceed to upload the trailer")
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
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
    );
  }

  File? pickedTrailerFile;

  Uint8List? thumbnailDataTrailer;

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

  Future<void> pickTrailerVideoFile() async {
    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      pickedTrailerFile = File(xFile.path);
    }
    loadingController.forward();
  }
}
