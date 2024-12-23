import 'dart:io';
import 'dart:typed_data';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_3_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MultipleFileStep3Screen extends StatefulWidget {
  const MultipleFileStep3Screen({super.key});

  @override
  State<MultipleFileStep3Screen> createState() =>
      _MultipleFileStep3ScreenState();
}

class _MultipleFileStep3ScreenState extends State<MultipleFileStep3Screen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Season> _seasons = [];
  late AnimationController loadingController;

  String showYear = 'Select Year';
  int selectedYear = 0;
  DateTime _selectedYear = DateTime.now();

  // Uint8List? thumbnailDataTrailer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<MultipleFileUploadStep3Provider>(context, listen: false);
      if (provider.seasonList.isEmpty) {
        _addSeason(); // Initialize with one season
      }
    });
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });
  }

  void _addSeason() {
    final index = _seasons.length;
    setState(() {
      _seasons.add(Season());
    });
    _listKey.currentState?.insertItem(index);
  }

  void _removeSeason(int index) {
    if (index < 0 || index >= _seasons.length) {
      print('Invalid index: $index');
      return;
    }

    final removedItem = _seasons[index];

    // Trigger the animation for item removal
    if (_listKey.currentState != null) {
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(context, removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );

      // Delay state update to allow animation to complete
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _seasons.removeAt(index);
        });
      });
    }
  }


  Future<void> _pickImage(int index) async {
    // final stepProvider =
    // Provider.of<Step3DTMFUploadProvider>(context, listen: false);
    final picker = ImagePicker();
    final imageFile = await picker.pickVideo(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _seasons[index].imageFile = File(imageFile.path);
        // stepProvider.settrailerMediaFile = _seasons[index].imageFile;
      });
      loadingController.forward();
    }
  }

  void _saveSeasons(MultipleFileUploadStep3Provider provider) async {
    if (_seasons.isNotEmpty) {
      for (final season in _seasons) {
        provider.title = season.titleController.text;
        provider.year = showYear;
        provider.settrailerMediaFile = season.imageFile;
        provider.settrailerMediaLink = season.trailerMediaLinkController.text;
      }

      try {
        await provider.Step3API();
        customSuccessToast(context, 'Seasons saved successfully');
      } catch (e) {
        customErrorToast(context, '$e');
      }
    } else {
      customErrorToast(context, 'Please add at least one season.');
    }
  }

  Future<void> _selectYear(
      {required BuildContext context,
      required void Function(DateTime) onChanged}) async {
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
                lastDate: DateTime(2025),
                currentDate: DateTime.now(),
                selectedDate: _selectedYear,
                onChanged: onChanged),
          ),
        );
      },
    );
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

  Widget _buildItem(
      BuildContext context, Season season, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: _seasonRow(context, _seasons.indexOf(season)),
      ),
    );
  }

  Widget _seasonRow(BuildContext context, int index) {
    final season = _seasons[index];
    final stepProvider =
        Provider.of<MultipleFileUploadStep3Provider>(context, listen: false);
    return   Container(
            // height: 280.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey.shade900.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.5),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeading("Enter your season name "),
                  SizedBox(height: 10.h),
                  _buildDescription("Enter the season name"),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CommonWidgets.CustomTextField(
                          borderRadius: BorderRadius.circular(8.r),
                          obscureText: false,
                          controller: season.titleController,
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
                            onPressed: () => _removeSeason(index)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildHeading("Pick year"),
                  SizedBox(height: 10.h),
                  _buildDescription("Select the year in which movie was made"),
                  SizedBox(height: 20.h),
                  _buildYearSelector(
                    onChanged: (DateTime dateTime) {
                      setState(() {
                        _selectedYear = dateTime;
                        showYear = "${dateTime.year}";
                      });

                      Navigator.pop(context);
                    },
                  ),
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
                        ? _uploadVideoTrailer(seasons: season, index: index)
                        : stepProvider.trailerType == "Url"
                            ? _buildTextField(
                                controller: season.trailerMediaLinkController,
                                hintText: 'Trailer Url')
                            : Container(), // Empty container when no option is selected
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
  }

  Widget _buildYearSelector({required void Function(DateTime) onChanged}) {
    return InkWell(
      onTap: () => _selectYear(context: context, onChanged: onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(showYear),
            Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateThumbnailTrailer(String videoPath, Season season) async {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );

    setState(() {
      season.thumbnailDataTrailer = thumbnail;
      // if (seasonIndex >= 0 && seasonIndex < _seasons.length) {
      //   _seasons[seasonIndex].thumbnailDataTrailer = thumbnail;
      // }
    });
  }

  Widget _uploadVideoTrailer({required Season seasons, required int index}) {
    // final stepProvider =
    // Provider.of<Step3DTMFUploadProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        _pickImage(index).then((value) {
          if (seasons.imageFile != null) {
            generateThumbnailTrailer(seasons.imageFile!.path, seasons);
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (seasons.imageFile != null)
            Column(
              children: [
                Lottie.asset(
                  AppConstants.successVideoUpload,
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
                const Text("Proceed to upload the trailer"),
                _buildFileDetails(seasons: seasons, index: index),
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

  Widget _buildFileDetails({required seasons, required int index}) {
    // final stepProvider =
    // Provider.of<Step3DTMFUploadProvider>(context, listen: false);

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
                seasons.thumbnailDataTrailer == null
                    ? SizedBox(
                        height: 30.w,
                        width: 30.w,
                        child: const CircularProgressIndicator())
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.memory(seasons.thumbnailDataTrailer!,
                            width: 70.w),
                      ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (seasons.imageFile != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                seasons.imageFile!.path.split('/').last,
                                style: TextStyle(
                                    fontSize: 13.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '${(seasons.imageFile!.lengthSync() / 1024).ceil()} KB',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return CommonWidgets.CustomTextField(
        controller: controller, hintText: hintText, obscureText: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultipleFileUploadStep3Provider>(
      builder: (context, provider, child) {
        bool isLoading = provider.pageStatus == DefaultPageStatus.loading;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading("Add Season Information"),
                SizedBox(
                  height: 10.h,
                ),
                _buildDescription(
                    "Include the title, year, and trailer media for the season. This information will help viewers know more about the season and its media."),
                SizedBox(height: 10.h),
                AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: _seasons.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(context, _seasons[index], animation);
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _addSeason(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        width: isLoading ? 50.w : 180.w, // Adjust width during loading
                        padding: EdgeInsets.all(isLoading ? 12.0 : 8.0), // Change padding during loading
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:isLoading ? 2.0 : 1.0, // Change border width during loading
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          color: Theme.of(context).colorScheme.surface.withOpacity(isLoading ? 0.4 : 0.2), // Change opacity during loading
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center contents
                          children: [
                            isLoading?SizedBox(height: 20.h,width: 20.w,child: const CircularProgressIndicator(),):Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            isLoading?const SizedBox.shrink(): const Text("Add New Season"),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _saveSeasons(provider),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        width: isLoading ? 220.w : 100.w, // Change width dynamically
                        padding: EdgeInsets.all(isLoading? 12.0 : 8.0), // Change padding during loading
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:isLoading ? 2.0 : 1.0, // Change border width during loading
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          color: Theme.of(context).colorScheme.surface.withOpacity(isLoading ? 0.4 : 0.2), // Change opacity during loading
                        ),
                        child: isLoading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center contents
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text("Saving your season ${provider.title}", overflow: TextOverflow.ellipsis),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center contents
                          children: [
                            Icon(
                              Icons.save_alt_rounded,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            const Text("Save"),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
    );
  }
}
