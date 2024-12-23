import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';
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

class EditSeasonPage extends StatefulWidget {
  final DashboardSeasonEntity? season;
  final int? dtID;

  const EditSeasonPage({super.key, required this.season, this.dtID});

  @override
  State<EditSeasonPage> createState() => _EditSeasonPageState();
}

class _EditSeasonPageState extends State<EditSeasonPage> {
  String? dropDownMovieType;
  File? videoFilesSeason;

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

      await generateSeasonThumbnail(file.path);
    }
    loadingController.forward();
  }

  Future<void> generateSeasonThumbnail(String videoPath) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      thumbnailSeasonTrailer = thumbnail;
    });
  }

  late TextEditingController seasonTitleController;
  late String seasonId;
  late TextEditingController seasonYearController;
  late TextEditingController seasonTrailerUrlController;

  String showYear = '';

  @override
  void initState() {
    super.initState();
    seasonTitleController = TextEditingController();
    seasonYearController = TextEditingController();
    seasonTrailerUrlController = TextEditingController();
    initializeVariables(context);
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
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              final provider = Provider.of<DTDashboardProvider>(
                  context,
                  listen: false);

           try{
             await provider.editDtSeason(seasonId, seasonTitleController.text,
                 showYear, seasonTrailerUrlController.text, videoFilesSeason);
           }finally{
             customSuccessToast(context,"Changes saved !!");
            await  provider.fetchDashboardDetails(digitalTheaterID: widget.dtID  .toString());
             final dtProvider =provider.digitalTheaterDashBoardEntity;
             Navigator.pop(context,dtProvider);
           }
            },
          ),
          SizedBox(
            width: 10.w,
          )
        ],
        title: const Text(
          "Edit Season",
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
          Text(
            'Season Information',
            style: TextStyle(fontSize: 22.sp),
          ),
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
            const Text("Season 1"),
            SizedBox(
              height: 10.h,
            ),
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
                    const Icon(
                      Icons.calendar_month,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text('Season Trailer Type',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(
              height: 20.h,
            ),
            CommonWidgets.CustomDropDown(
                context: context,
                hintText: 'Season Trailer Type',
                items: const ["link", "file", "both"],
                selectedValue: dropDownMovieType,
                onChanged: (value) => {
                      setState(() {
                        dropDownMovieType = value;
                      })
                    },
                buttonWidth: 160.w,
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
                                                  )),
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
                                                          ).animate().shimmer(),
                                                        ),
                                                      ],
                                                    )),
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
                                                      )),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CommonWidgets.CustomTextField(
                              borderRadius: BorderRadius.circular(8.r),
                              obscureText: false,
                              controller: seasonTrailerUrlController,
                              hintText: "Trailer URL",
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : const SizedBox.shrink(),
            dropDownMovieType == "link"
                ? Row(
                    children: [
                      Expanded(
                        child: CommonWidgets.CustomTextField(
                          borderRadius: BorderRadius.circular(8.r),
                          obscureText: false,
                          controller: seasonTrailerUrlController,
                          hintText: "Trailer URL",
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Future<void> selectYear(BuildContext context, bool isSeason) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedYear,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Year',
      fieldLabelText: 'Year',
      fieldHintText: 'Year',
    );

    if (picked != null) {
      setState(() {
        _selectedYear = picked;
        showYear = "${_selectedYear.year}";
      });
    }
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

  void initializeVariables(BuildContext context) {
    final season = widget.season;
    if (season != null) {
      seasonTitleController.text = season.name;
      seasonId = season.id.toString();
      seasonYearController.text = season.year.toString();
      seasonTrailerUrlController.text = season.trailerMediaLink ?? '';
      showYear = season.year.toString();
      dropDownMovieType = season.trailerType;
      season.trailerMediaFile != null
          ? videoFilesSeason = File.fromUri(Uri.parse(season.trailerMediaFile!))
          : null;
    }
  }
}
