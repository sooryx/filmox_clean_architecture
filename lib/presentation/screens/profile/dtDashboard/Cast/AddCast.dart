import 'dart:io';

import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCast extends StatefulWidget {
  final String dtID;

  const AddCast({super.key, required this.dtID});

  @override
  _AddCastState createState() => _AddCastState();
}

class _AddCastState extends State<AddCast> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  String? imagePath;

  File? image;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
        image = File(pickedImage.path);
      });
    }
  }

  bool _validateInputs() {
    return nameController.text.isNotEmpty &&
        roleController.text.isNotEmpty &&
        imagePath != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 450.h,
          padding: EdgeInsets.all(20.dg),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _uploadImage,
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Image.file(
                          File(imagePath!),
                          height: 120.h,
                        ),
                      )
                    : Image.asset(
                        AppConstants.uploadIcon,
                        height: 120.h,
                      ),
              ),
              const SizedBox(height: 20),
              CommonWidgets.CustomTextField(
                obscureText: false,
                controller: nameController,
                hintText: "Name",
              ),
              SizedBox(height: 10.h),
              CommonWidgets.CustomTextField(
                obscureText: false,
                controller: roleController,
                hintText: "Role",
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (_validateInputs()) {
                    try {
                      final dashboardProvider =
                          Provider.of<DTDashboardProvider>(context,
                              listen: false);
                      await dashboardProvider
                          .addNewCastData(
                              dtID: widget.dtID,
                              name: nameController.text,
                              role: roleController.text,
                              imageFile: image ?? File(''))
                          .then(
                        (value) async {
                          await dashboardProvider.fetchDashboardDetails(
                              digitalTheaterID: widget.dtID);
                        },
                      );
                      customSuccessToast(context, "Cast Added");
                      Navigator.pop(context,
                          dashboardProvider.digitalTheaterDashBoardEntity);
                    } catch (e) {
                      customErrorToast(context, "Not Saved");
                    }
                  } else {
                    customErrorToast(
                        context, 'Please fill all fields and upload an image.');
                  }
                },
                child: const Text('Add Cast'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
