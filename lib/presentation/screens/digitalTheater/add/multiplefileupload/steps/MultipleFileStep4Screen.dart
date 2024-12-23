import 'dart:io';

import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/multipleFileUploadRepo/multiple_file_upload_step_4_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MultipleFileStep4Screen extends StatefulWidget {
  const MultipleFileStep4Screen({super.key});

  @override
  State<MultipleFileStep4Screen> createState() => _MultipleFileStep4ScreenState();
}

class _MultipleFileStep4ScreenState extends State<MultipleFileStep4Screen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<CastMember> _castMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MultipleFileUploadStep4Provider>(context, listen: false);
      if (provider.castList.isEmpty) {
        _addCastMember(); // Initialize with one cast member
      }
    });
  }

  void _addCastMember() {
    final index = _castMembers.length;
    setState(() {
      _castMembers.add(CastMember());
    });
    _listKey.currentState?.insertItem(index);
  }

  void _removeCastMember(int index) {
    if (index < 0 || index >= _castMembers.length) {
      print('Invalid index: $index');
      return;
    }

    final removedItem = _castMembers[index];

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
          _castMembers.removeAt(index);
        });
      });
    }
  }


  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _castMembers[index].imageFile = File(imageFile.path);
      });
    }
  }

  void _saveCastMembers(MultipleFileUploadStep4Provider provider) async {
    if (_castMembers.isNotEmpty) {
      for (final cast in _castMembers) {
        provider.name = cast.nameController;
        provider.role = cast.roleController;
        provider.image = cast.imageFile ?? File('');
      }

      try {
        await provider.Step4Api(dtID: null);
        customSuccessToast(context, 'Cast members saved successfully');
      } catch (e) {
        customErrorToast(context, e.toString());
      }
    } else {
      customErrorToast(context, 'Please add at least one cast member.');
    }
  }

  Widget _buildItem(BuildContext context, CastMember castMember, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: _castMemberRow(context, _castMembers.indexOf(castMember)),
      ),
    );
  }

  Widget _castMemberRow(BuildContext context, int index) {
    final castMember = _castMembers[index];
    return Container(
      height: 210.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(colors: [
          Colors.grey.shade900.withOpacity(0.9),
          Colors.grey.shade900,
          Colors.grey.shade900.withOpacity(0.9),
          Colors.grey.shade900,
          Colors.grey.shade900.withOpacity(0.9),
        ]),
        boxShadow: const [
          BoxShadow(
            color: Colors.cyan,
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Row(
          children: [
            castMember.imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                castMember.imageFile!,
                width: 80.w,
                height: 180.h,
                fit: BoxFit.cover,
              ),
            )
                : InkWell(
              onTap: () => _pickImage(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                height: 180.h,
                width: 100.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_file, size: 40),
                    Text(
                      "Choose A File",
                      style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonWidgets.CustomTextField(
                    hintText: "Name",
                    obscureText: false,
                    controller: castMember.nameController,
                  ),
                  SizedBox(height: 20.h),
                  CommonWidgets.CustomTextField(
                    hintText: "Role",
                    obscureText: false,
                    controller: castMember.roleController,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
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
                onPressed: () => _removeCastMember(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultipleFileUploadStep4Provider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading("Add Cast Information"),
                SizedBox(
                  height: 10.h,
                ),
                _buildDescription(
                    "Include the names and roles of the cast members for the movie. This information will help viewers know who is in the film and their respective roles."),
                SizedBox(height: 10.h),
                AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: _castMembers.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(context, _castMembers[index], animation);
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _addCastMember(),
                      child: Container(
                        padding: EdgeInsets.all(8.dg),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.surface),
                            borderRadius: BorderRadius.circular(10.r),
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.2)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            const Text("Add New Cast"),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _saveCastMembers(provider),
                      child: Container(
                        padding: EdgeInsets.all(8.dg),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.surface),
                            borderRadius: BorderRadius.circular(10.r),
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.2)),
                        child: Row(
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
                ),
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
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class CastMember {
  File? imageFile;
  final nameController = TextEditingController();
  final roleController = TextEditingController();
}
