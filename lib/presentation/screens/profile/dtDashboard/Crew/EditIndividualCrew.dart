import 'dart:io';

import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditIndividualCrew extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController roleController;
  final String imgFile;
  final int id;

  const EditIndividualCrew({super.key,
    required this.nameController,
    required this.roleController,
    required this.imgFile, required this.id});

  @override
  State<EditIndividualCrew> createState() => _EditIndividualCrewState();
}

class _EditIndividualCrewState extends State<EditIndividualCrew> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Crew Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            color: Colors.green,
            onPressed: () async {
              final dashboardProvider =
              Provider.of<DTDashboardProvider>(context,
                  listen: false);
              await dashboardProvider
                  .editCrewData(
                  id: widget.id.toString(),
                  name: widget.nameController.text,
                  role: widget.roleController.text,
                  image: _imageFile)
                  .then(
                    (value) async {
                  await dashboardProvider.fetchDashboardDetails(
                      digitalTheaterID: widget.id.toString());
                },
              );
              customSuccessToast(context, "Cast Edited");
              Navigator.pop(
                  context, dashboardProvider.digitalTheaterDashBoardEntity);
            },
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildCrewMemberRow(),
      ),
    );
  }

  Widget _buildCrewMemberRow() {
    return Container(
      height: 450.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: Image.file(
                      _imageFile!,
                      width: 180.w,
                      height: 180.h,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: Image.network(
                        "${UrlStrings.imageUrl}${widget.imgFile}",
                        width: 180.w,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(width: 12.w),
                SizedBox(width: 10.w),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            CommonWidgets.CustomTextField(
              borderRadius: BorderRadius.circular(20.r),
              obscureText: false,
              controller: widget.nameController,
              hintText: "Name",
            ),
            SizedBox(height: 20.h),
            CommonWidgets.CustomTextField(
              borderRadius: BorderRadius.circular(20.r),
              controller: widget.roleController,
              hintText: 'Role',
              obscureText: false,
            ),
            SizedBox(height: 20.h),
            TextButton(onPressed: () async {
              try{

                customSuccessToast(context, "Changes Saved Succesfully");
                Navigator.pop(context);

              }catch(e){
                customErrorToast(context, "Not able to save the chanegs ");
              }


            }, child: const Text("Save Changes"))
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
