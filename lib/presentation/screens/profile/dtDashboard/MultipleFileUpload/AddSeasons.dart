import 'dart:io';
import 'dart:typed_data';


import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddSeason extends StatefulWidget {
  final int? dt_id;

  const AddSeason({
    super.key,
    this.dt_id,
  });

  @override
  State<AddSeason> createState() => _AddSeasonState();
}

class _AddSeasonState extends State<AddSeason> {
  final TextEditingController seasonTitleController = TextEditingController();
  final String seasonId = '';

  final TextEditingController seasonYearController = TextEditingController();

  final TextEditingController seasonTrailerUrlController =
      TextEditingController();
  String? dropDownMovieType;
  File? videoFilesSeason;

  String showYear = '';
  Uint8List? thumbnailSeasonTrailer;

  Uint8List? generateEmptyThumbnailSeason() => null;
  late AnimationController loadingController;
  DateTime _selectedYear = DateTime.now();

  Future<void> pickedSeasonTrailerFile() async {
    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      final file = File(xFile.path);

      setState(() {
        videoFilesSeason = file;
      });

      await generateSeasonThumbnail(
        file.path,
      );
    }
    loadingController.forward();
  }

  Future<void> generateSeasonThumbnail(
    String videoPath,
  ) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      thumbnailSeasonTrailer = thumbnail;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check,
                color: Colors.green),
            onPressed: () async {
              final dtProvier = Provider.of<DTDashboardProvider>(
                  context,
                  listen: false);
              try {
                await dtProvier.addNewSeason(
                  dt_id: widget.dt_id.toString(),
                  title: seasonTitleController.text,
                  trailerMediaFile: videoFilesSeason,
                  trailerMediaLink: seasonTrailerUrlController.text,
                  year: showYear
                );
              } finally {
                customSuccessToast(context, "Changes saved !!");
                await dtProvier.fetchDashboardDetails(digitalTheaterID: widget.dt_id .toString());
                final dtProvider = dtProvier.digitalTheaterDashBoardEntity;
                Navigator.pop(context, dtProvider);
              }
            },
          ),
          SizedBox(
            width: 10.w,
          )
        ],
        title: const Text(
          "Add Season",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _step3(),
    );
  }

  _step3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSeason(),
          SizedBox(height: 10.h),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  _buildSeason() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 20.h),
            const Text("Add the season title"),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.CustomTextField(
                    borderRadius: BorderRadius.circular(8.r),
                    obscureText: false,
                    controller: seasonTitleController,
                    hintText: "Title",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            const Text("Add the year which you published the season"),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                selectYear(context, true);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 15.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      showYear,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.surface,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Season Trailer Type",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            const Text("Choose the file type which you are gonna upload."),
            SizedBox(height: 10.h),
            CommonWidgets.CustomDropDown(
                context: context,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: 'Season Trailer Type',
                items: const ["link", "file", "both"],
                selectedValue: dropDownMovieType,
                onChanged: (value) => {
                      setState(() {
                        dropDownMovieType = value;
                      })
                    },
                buttonWidth: 220.w,
                buttonHeight: 60.h),
            SizedBox(height: 20.h),
            dropDownMovieType == "file"
                ? GestureDetector(
                    child: Column(
                      children: [
                        uploadSeasonwiseTrailer(),
                        videoFilesSeason != null &&
                                thumbnailSeasonTrailer != null
                            ? Container(
                                padding: EdgeInsets.all(20.dg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.dg),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                                          thumbnailSeasonTrailer == null
                                              ? SizedBox(
                                                  height: 30.w,
                                                  width: 30.w,
                                                  child:
                                                      const CircularProgressIndicator())
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  child: Image.memory(
                                                    thumbnailSeasonTrailer!,
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
                                                        videoFilesSeason!.path
                                                            .split('/')
                                                            .last,
                                                        style: TextStyle(
                                                            fontSize: 13.sp,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () {
                                                        // Add functionality to delete the file
                                                        setState(() {
                                                          videoFilesSeason =
                                                              null;
                                                          thumbnailSeasonTrailer =
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
                                                  '${(videoFilesSeason!.lengthSync() / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Container(
                                                    height: 20.h,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                        color:
                                                            Colors.transparent),
                                                    child: Row(
                                                      children: [
                                                        Lottie.asset(
                                                            "${AppConstants.baseAnimation}success.json"),
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
                                                          ).animate().shimmer(),
                                                        ),
                                                      ],
                                                    )),
                                                // Text(loadingControllerTrailer.value)
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            dropDownMovieType == 'both'
                ? Column(
                    children: [
                      GestureDetector(
                        child: Column(
                          children: [
                            uploadSeasonwiseTrailer(),
                            videoFilesSeason != null &&
                                    thumbnailSeasonTrailer != null
                                ? Container(
                                    padding: EdgeInsets.all(20.dg),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selected File',
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.dg),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            gradient: LinearGradient(colors: [
                                              Colors.grey.shade800
                                                  .withOpacity(0.9),
                                              Colors.grey.shade800,
                                              Colors.grey.shade800
                                                  .withOpacity(0.9),
                                              Colors.grey.shade800,
                                              Colors.grey.shade800
                                                  .withOpacity(0.9),
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
                                              thumbnailSeasonTrailer == null
                                                  ? SizedBox(
                                                      height: 30.w,
                                                      width: 30.w,
                                                      child:
                                                          const CircularProgressIndicator())
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      child: Image.memory(
                                                        thumbnailSeasonTrailer!,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            videoFilesSeason!
                                                                .path
                                                                .split('/')
                                                                .last,
                                                            style: TextStyle(
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            // Add functionality to delete the file
                                                            setState(() {
                                                              videoFilesSeason =
                                                                  null;
                                                              thumbnailSeasonTrailer =
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
                                                      '${(videoFilesSeason!.lengthSync() / 1024).ceil()} KB',
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: Colors
                                                            .grey.shade500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Container(
                                                        height: 20.h,
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                            color: Colors
                                                                .transparent),
                                                        child: Row(
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
                                                        )),
                                                    // Text(loadingControllerTrailer.value)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CommonWidgets.CustomTextField(
                        borderRadius: BorderRadius.circular(20.r),
                        controller: seasonTrailerUrlController,
                        hintText: 'Movie Url',
                        obscureText: false,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            dropDownMovieType == 'link'
                ? CommonWidgets.CustomTextField(
                    borderRadius: BorderRadius.circular(20.r),
                    controller: seasonTrailerUrlController,
                    hintText: 'Movie Url',
                    obscureText: false,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  selectYear(context, bool isSeason) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300.w,
            height: 300.h,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 10, 1),
              // lastDate: DateTime.now(),
              lastDate: DateTime(2025),
              currentDate: DateTime.now(),
              selectedDate: _selectedYear,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime;
                  showYear = "${dateTime.year}";
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  uploadSeasonwiseTrailer() {
    return InkWell(
      onTap: () {
        pickedSeasonTrailerFile();
      },
      child: Column(
        children: [
          videoFilesSeason != null && thumbnailSeasonTrailer != null
              ? Container()
              : Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 2,
                      color: Colors.blue.withOpacity(0.8),
                    ),
                  ),
                  child: videoFilesSeason == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              size: 50,
                              color: Colors.blue.withOpacity(0.8),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Choose the trailer video file",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_collection_outlined,
                              size: 50,
                              color: Colors.blue.withOpacity(0.8),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              videoFilesSeason!.path,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                            )
                          ],
                        )),
        ],
      ),
    );
  }
}
