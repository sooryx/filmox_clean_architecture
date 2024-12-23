import 'dart:io';

import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_5.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SingleFileUploadStep5Screen extends StatefulWidget {
  const SingleFileUploadStep5Screen({super.key});

  @override
  State<SingleFileUploadStep5Screen> createState() => _SingleFileUploadStep5ScreenState();
}

class _SingleFileUploadStep5ScreenState extends State<SingleFileUploadStep5Screen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<CrewMember> _crewMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<Step5SFUploadProvider>(context, listen: false);
      if (provider.crewList.isEmpty) {
        _addCrewMember(); // Initialize with one crew member
      }
    });
  }

  void _addCrewMember() {
    final index = _crewMembers.length;
    setState(() {
      _crewMembers.add(CrewMember());
    });
    _listKey.currentState?.insertItem(index);
  }

  void _removeCrewMember(int index) {
    if (index < 0 || index >= _crewMembers.length) {
      print('Invalid index: $index');
      return;
    }

    final removedItem = _crewMembers[index];

    if (_listKey.currentState != null) {
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildItem(context, removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _crewMembers.removeAt(index);
        });
      });
    }
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _crewMembers[index].imageFile = File(imageFile.path);
      });
    }
  }

  void _saveCrewMembers(Step5SFUploadProvider provider) async {
    if (_crewMembers.isNotEmpty) {
      for (final crew in _crewMembers) {
        provider.name = crew.nameController;
        provider.role = crew.roleController;
        provider.image = crew.imageFile ?? File('');
      }

      try {
        await provider.Step5Api();
        customSuccessToast(context, 'Crew members saved successfully');
      } catch (e) {
        customErrorToast(context, e.toString());
      }
    } else {
      customErrorToast(context, 'Please add at least one crew member.');
    }
  }

  Widget _buildItem(BuildContext context, CrewMember crewMember, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: _crewMemberRow(context, _crewMembers.indexOf(crewMember)),
      ),
    );
  }

  Widget _crewMemberRow(BuildContext context, int index) {
    final crewMember = _crewMembers[index];
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
            crewMember.imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                crewMember.imageFile!,
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
                    controller: crewMember.nameController,
                  ),
                  SizedBox(height: 20.h),
                  CommonWidgets.CustomTextField(
                    hintText: "Role",
                    obscureText: false,
                    controller: crewMember.roleController,
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
                onPressed: () => _removeCrewMember(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Step5SFUploadProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading("Add Crew Information"),
                SizedBox(
                  height: 10.h,
                ),
                _buildDescription(
                    "Include the names and roles of the crew members for the movie. This information helps viewers understand the behind-the-scenes talent involved."),
                SizedBox(height: 10.h),
                AnimatedList(
                  key: _listKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: _crewMembers.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(context, _crewMembers[index], animation);
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _addCrewMember(),
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
                            const Text("Add New Crew"),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _saveCrewMembers(provider),
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

class CrewMember {
  File? imageFile;
  final nameController = TextEditingController();
  final roleController = TextEditingController();
}
