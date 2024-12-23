import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';

class AddEpisodePage extends StatefulWidget {
  final String seasonTitle;
  final String seasonID;
  final String DigitalTheaterId;

  const AddEpisodePage(
      {super.key,
      required this.seasonTitle,
      required this.seasonID,
      required this.DigitalTheaterId});

  @override
  State<AddEpisodePage> createState() => _AddEpisodePageState();
}

class _AddEpisodePageState extends State<AddEpisodePage> {
  final List<TextEditingController> _titleControllerEpisode = [];

  final List<TextEditingController> _descriptionController = [];

  final List<TextEditingController> _movieUrlControllerEpisode = [];

  final List<File?> _videoFilesEpisode = [];

  List<Uint8List?> thumbnailEpisodeTrailer = [];

  Uint8List? generateEmptyThumbnailEpisode() => null;

  String showYear = 'Select Year';
  int selectedYear = 0;

  Future<void> pickedSeasonTrailerFile(int index) async {
    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      final file = File(xFile.path);

      setState(() {
        _videoFilesEpisode[index] = file;
      });

      await generateEpisodeThumbnail(file.path, index);
    }
  }

  Future<void> generateEpisodeThumbnail(String videoPath, int index) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      // Ensure that the list has the proper length before inserting
      if (index < thumbnailEpisodeTrailer.length) {
        thumbnailEpisodeTrailer[index] = thumbnail;
      } else {
        thumbnailEpisodeTrailer.add(thumbnail);
      }
    });
  }

  void _addEpisode() async {
    showLoadingDialog(
        context: context, message: "Adding Episode ...", lottie: null);
    int i = _titleControllerEpisode.length - 1;

    try {
      final dtProvider = Provider.of<DTDashboardProvider>(context,listen:false);

      await dtProvider.sendEpisodeData(
          context,
          widget.DigitalTheaterId.toString(),
          widget.seasonID,
          _titleControllerEpisode[i].text,
          _descriptionController[i].text,
          _videoFilesEpisode[i],
          _movieUrlControllerEpisode[i].text).then((value)async {
            await dtProvider.fetchDashboardDetails(digitalTheaterID: widget.DigitalTheaterId);
          },);

      setState(() {
        _titleControllerEpisode.add(TextEditingController());
        _descriptionController.add(TextEditingController());
        _movieUrlControllerEpisode.add(TextEditingController());
        _videoFilesEpisode.add(null);
      });
      Navigator.pop(context);
    } on Exception {
      customErrorToast(context, "Error adding episdoes");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_titleControllerEpisode.isEmpty) {
      _titleControllerEpisode.add(TextEditingController());
      _descriptionController.add(TextEditingController());
      _movieUrlControllerEpisode.add(TextEditingController());
      _videoFilesEpisode.add(null);
      thumbnailEpisodeTrailer.add(generateEmptyThumbnailEpisode());
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Theme.of(context).colorScheme.surface),
                    onPressed: () async {
                      final dtProvider = Provider.of<DTDashboardProvider>(context,listen:false);

                      await dtProvider.fetchDashboardDetails(digitalTheaterID: widget.DigitalTheaterId);

                      Navigator.pop(context,dtProvider.digitalTheaterDashBoardEntity);

                    },
                  ),
          title: Text(
            widget.seasonTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _videoFilesEpisode.length,
                padding: EdgeInsets.all(10.dg),
                itemBuilder: (context, index) {
                  return _buildSeason(index);
                },
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  _addEpisode();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320.w,
                      padding: EdgeInsets.all(12.dg),

                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.surface)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Tap here to add the above episode",
                            style: TextStyle(fontSize: 14.sp),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ));
  }

  Widget _buildSeason(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headlineWidget(
                title: "Episode ${index + 1}",
                description: "Upload File or URL of the episode."),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.CustomTextField(
                    borderRadius: BorderRadius.circular(8.r),
                    obscureText: false,
                    controller: _titleControllerEpisode[index],
                    hintText: "Title",
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    onPressed: () => _removeSeasonData(index),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            headlineWidget(
                title: "Description",
                description: "Enter the descritpion of the movie"),

            CommonWidgets.CustomTextField(
              hintText: 'Description',
              obscureText: false,
              controller: _descriptionController[index],
              borderRadius: BorderRadius.circular(20.r),
              maxLines: 4,
            ),
            SizedBox(height: 20.h),
            headlineWidget(title: "Upload Episode", description:"Uplaod your episode file or give the url"),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              child: Column(
                children: [
                  uploadSeasonwiseTrailer(index),
                  _videoFilesEpisode[index] != null &&
                          thumbnailEpisodeTrailer[index] != null
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
                                    thumbnailEpisodeTrailer[index] == null
                                        ? SizedBox(
                                            height: 30.w,
                                            width: 30.w,
                                            child:
                                                const CircularProgressIndicator())
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.memory(
                                              thumbnailEpisodeTrailer[index]!,
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
                                                  _videoFilesEpisode[index]!
                                                      .path
                                                      .split('/')
                                                      .last,
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  // Add functionality to delete the file
                                                  setState(() {
                                                    _videoFilesEpisode[index] =
                                                        null;
                                                    thumbnailEpisodeTrailer[
                                                        index] = null;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            '${(_videoFilesEpisode[index]!.lengthSync() / 1024).ceil()} KB',
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
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color: Colors.transparent),
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
                                                          color: Colors.green,
                                                          fontSize: 12.sp),
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
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "OR",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            CommonWidgets.CustomTextField(
              borderRadius: BorderRadius.circular(10.r),
              controller: _movieUrlControllerEpisode[index],
              hintText: 'Movie Url',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }

  void _removeSeasonData(int index) {
    if (index == 0) {
      customErrorToast(context, "Atleast one season is required");
    } else {
      setState(() {
        _titleControllerEpisode.removeAt(index);
        _movieUrlControllerEpisode.removeAt(index);
        _videoFilesEpisode.removeAt(index);

        if (index < thumbnailEpisodeTrailer.length) {
          thumbnailEpisodeTrailer.removeAt(index);
        }
      });
    }
  }

  Widget uploadSeasonwiseTrailer(int index) {
    return InkWell(
      onTap: () {
        pickedSeasonTrailerFile(index);
      },
      child: Column(
        children: [
          _videoFilesEpisode[index] != null &&
                  thumbnailEpisodeTrailer[index] != null
              ? Container()
              : Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
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
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget headlineWidget({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
