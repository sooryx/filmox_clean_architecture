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

  const AddCast({Key? key, required this.dtID}) : super(key: key);

  @override
  _AddCastState createState() => _AddCastState();
}

class _AddCastState extends State<AddCast> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _roleController.text.isNotEmpty &&
        _imageFile != null;
  }

  Future<void> _handleAddCast(BuildContext context) async {
    if (!_validateInputs()) {
      customErrorToast(
        context,
        'Please fill all fields and upload an image.',
      );
      return;
    }

    try {
      final dashboardProvider =
      Provider.of<DTDashboardProvider>(context, listen: false);

      await dashboardProvider.addNewCastData(
        dtID: widget.dtID,
        name: _nameController.text,
        role: _roleController.text,
        imageFile: _imageFile!,
      );

      await dashboardProvider.fetchDashboardDetails(
        digitalTheaterID: widget.dtID,
      );

      customSuccessToast(context, "Cast Added");
      Navigator.pop(context, dashboardProvider.digitalTheaterDashBoardEntity);
    } catch (e) {
      customErrorToast(context, "Not Saved. Error: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.surface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Cast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 450.h,
          padding: EdgeInsets.all(20.dg),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Image.file(
                    _imageFile!,
                    height: 120.h,
                    fit: BoxFit.cover,
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
                controller: _nameController,
                hintText: "Name",
              ),
              SizedBox(height: 10.h),
              CommonWidgets.CustomTextField(
                obscureText: false,
                controller: _roleController,
                hintText: "Role",
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _handleAddCast(context),
                child: const Text('Add Cast'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
