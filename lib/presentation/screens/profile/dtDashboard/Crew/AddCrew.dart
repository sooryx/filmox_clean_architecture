import 'dart:io';

import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import image_picker

class AddCrew extends StatefulWidget {
  final int dtID;

  const AddCrew({super.key, required this.dtID});

  @override
  _AddCrewState createState() => _AddCrewState();
}

class _AddCrewState extends State<AddCrew> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add Crew'),
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
                      final provider =
                          Provider.of<DTDashboardProvider>(context,
                              listen: false);
                      provider
                          .addNewCrewData(

                          dtID: widget.dtID.toString(),
                          name: nameController.text,
                          role: roleController.text,
                          imageFile: image ?? File(""))
                          .then((value) async {
                        await provider.fetchDashboardDetails(digitalTheaterID: widget.dtID.toString());
                        customSuccessToast(context, "Crew Added");
                        Navigator.pop(context, provider.digitalTheaterDashBoardEntity);
                      });


                    } catch (e) {
                      customErrorToast(context, "Not Saved");
                    }
                  } else {
                    customErrorToast(
                        context, 'Please fill all fields and upload an image.');
                  }
                },
                child: const Text('Add Crew'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
