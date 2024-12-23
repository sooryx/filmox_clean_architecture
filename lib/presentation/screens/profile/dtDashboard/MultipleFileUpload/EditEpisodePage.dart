import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EditEpisodePage extends StatefulWidget {
  final DashboardEpisodeEntity episode;

  const EditEpisodePage({
    super.key,
    required this.episode,
  });

  @override
  State<EditEpisodePage> createState() => _EditEpisodePageState();
}

class _EditEpisodePageState extends State<EditEpisodePage> {
  Uint8List? thumbnailepisodeTrailer;

  Uint8List? generateEmptyThumbnailepisode() => null;
  late AnimationController loadingController;
  late TextEditingController episodeTitleController;
  late TextEditingController episodeDescriptionController;
  late String episodeId;
  late TextEditingController? episodeUrl;

  String? dropDownMovieType;
  File? videoFilesepisode;

  Future<void> pickedepisodeTrailerFile() async {
    final xFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (xFile != null) {
      final file = File(xFile.path);

      setState(() {
        videoFilesepisode = file;
      });

      await generateepisodeThumbnail(
        file.path,
      );
    }
    loadingController.forward();
  }

  Future<void> generateepisodeThumbnail(
    String videoPath,
  ) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    setState(() {
      thumbnailepisodeTrailer = thumbnail;
    });
  }

  @override
  void initState() {
    super.initState();
    episodeTitleController = TextEditingController();
    episodeDescriptionController = TextEditingController();
    episodeUrl = TextEditingController();
    intializeVariables();
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
        title: const Text(
          "Edit episode",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _step3(),
    );
  }

  Widget _step3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'episode Information',
            style: TextStyle(fontSize: 22.sp),
          ),
          _buildepisode(),
          SizedBox(height: 10.h),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildepisode() {
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
            const Text("Episode Title"),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.CustomTextField(
                    borderRadius: BorderRadius.circular(8.r),
                    obscureText: false,
                    controller: episodeTitleController,
                    hintText: "Title",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Episode Type",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 20.h,
            ),
            CommonWidgets.CustomDropDown(
                context: context,
                hintText: 'Episode Type',
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
                        uploadepisodewiseTrailer(),
                        videoFilesepisode != null &&
                                thumbnailepisodeTrailer != null
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
                                          thumbnailepisodeTrailer == null
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
                                                    thumbnailepisodeTrailer!,
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
                                                        videoFilesepisode!.path
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
                                                          videoFilesepisode =
                                                              null;
                                                          thumbnailepisodeTrailer =
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
                                                  '${(videoFilesepisode!.lengthSync() / 1024).ceil()} KB',
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
                            uploadepisodewiseTrailer(),
                            videoFilesepisode != null &&
                                    thumbnailepisodeTrailer != null
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
                                              thumbnailepisodeTrailer == null
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
                                                        thumbnailepisodeTrailer!,
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
                                                            videoFilesepisode!
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
                                                              videoFilesepisode =
                                                                  null;
                                                              thumbnailepisodeTrailer =
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
                                                      '${(videoFilesepisode!.lengthSync() / 1024).ceil()} KB',
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
                        controller: episodeUrl,
                        hintText: 'Movie Url',
                        obscureText: false,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            dropDownMovieType == 'link'
                ? CommonWidgets.CustomTextField(
                    borderRadius: BorderRadius.circular(20.r),
                    controller: episodeUrl,
                    hintText: 'Movie Url',
                    obscureText: false,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 20.h,
            ),
            // RoundButton(
            //     onTap: () async {
            //       await DigitalDahsboardRepo().editdtepisode(
            //           widget.episodeId,
            //           widget.episodeTitleController.text,
            //           widget.episodeDescriptionController.text,
            //           widget.episodeUrl?.text,
            //           widget.videoFilesepisode);
            //     },
            //     icon: const Icon(
            //       Icons.check,
            //       color: Colors.white,
            //     ))
          ],
        ),
      ),
    );
  }

  Widget uploadepisodewiseTrailer() {
    return InkWell(
      onTap: () {
        pickedepisodeTrailerFile();
      },
      child: Column(
        children: [
          videoFilesepisode != null && thumbnailepisodeTrailer != null
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
                  child: videoFilesepisode == null
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
                              videoFilesepisode!.path,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                            )
                          ],
                        )),
        ],
      ),
    );
  }

  void intializeVariables() {
    final episode = widget.episode;
    episodeTitleController = TextEditingController(text: episode.name);
    episodeDescriptionController =
        TextEditingController(text: episode.description);
    episodeUrl = TextEditingController(text: episode.link);
    episodeId = episode.id.toString();
    dropDownMovieType = episode.type;
  episode.media !=null?  videoFilesepisode =  File.fromUri(Uri.parse(episode.media!)):null;
  }
}
