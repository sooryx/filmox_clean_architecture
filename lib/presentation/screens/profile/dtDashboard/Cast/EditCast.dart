import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/profile/dtDashboard/DashBoardHelper.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'AddCast.dart';
import 'EditIndividualCast.dart';

class EditCast extends StatefulWidget {
  final String dtId;

  const EditCast({super.key, required this.dtId});

  @override
  State<EditCast> createState() => _EditCastState();
}

class _EditCastState extends State<EditCast> {
  final List<TextEditingController> _nameControllersCast = [];
  final List<TextEditingController> _roleControllersCast = [];
  final List<File?> _imageFilesCast = [];
  final List<bool> _isNewCast = [];

  @override
  void initState() {
    super.initState();
    _initializeControllersAndFiles();
  }

  void _initializeControllersAndFiles() {
    _nameControllersCast.clear();
    _roleControllersCast.clear();
    _imageFilesCast.clear();
    _isNewCast.clear();
    final dashboardProvider =
        Provider.of<DTDashboardProvider>(context, listen: false);
    final cast = dashboardProvider.digitalTheaterDashBoardEntity?.cast;
    cast?.forEach((castMember) {
      _nameControllersCast.add(TextEditingController(text: castMember.name));
      _roleControllersCast.add(TextEditingController(text: castMember.role));
      _imageFilesCast.add(null);
      _isNewCast.add(false); // Existing cast members are not new
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.surface),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Cast Information'),
        ),
        body: Consumer<DTDashboardProvider>(
          builder: (context, digitalProvider, state) {
            final cast = digitalProvider.digitalTheaterDashBoardEntity?.cast;
            return SingleChildScrollView(
              child: Column(
                children: [
                  cast!.isNotEmpty
                      ? ListView.builder(
                          itemCount: cast.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    color: Colors.red),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                showLoadingDialog(
                                    context: context,
                                    message: "Deleting cast ...",
                                    lottie: null);

                                try {
                                  final dashboardProvider = Provider.of<
                                          DTDashboardProvider>(
                                      context,
                                      listen: false);
                                  await dashboardProvider.deleteCastData(
                                    context: context,
                                    id: widget.dtId ,
                                    name: cast[index].name,
                                    role: cast[index].name,
                                  );
                                } catch (e) {
                                  customErrorToast(
                                      context, "Error:${e.toString()}");
                                } finally {
                                  Navigator.pop(context);
                                }
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: EditIndividualCast(
                                            nameController:
                                                TextEditingController(
                                                    text: cast[index].name),
                                            roleController:
                                                TextEditingController(
                                                    text: cast[index].role),
                                            imgFile: cast[index].image,
                                            id: cast[index].id ?? 0,
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.dg),
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
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
                                          spreadRadius: 1,
                                        )
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          imageUrl:
                                              '${UrlStrings.imageUrl}${cast[index].image}',
                                          fit: BoxFit.cover,
                                          height: 60.h,
                                          width: 60.w,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cast[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp),
                                          ),
                                          Text(
                                            cast[index].role,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.sp),
                                          ),
                                        ],
                                      )),
                                      InkWell(
                                        onTap: () {
                                          DashBoardHelper().deleteCast(
                                              context: context,
                                              digiID: widget.dtId,
                                              castName: cast[index].name,
                                              role: cast[index].role);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.dg),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.red.withOpacity(0.3)),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 22.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: cast.isNotEmpty ? 20.h : 350.h,
                        ),
                  cast.isEmpty
                      ? const Text(
                          textAlign: TextAlign.center,
                          "No data available, Tap the button below to add new crew members")
                      : const SizedBox.shrink(),
                  cast.isEmpty
                      ? SizedBox(
                          height: 20.h,
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AddCast(
                                dtID: widget.dtId ,
                              ),
                              type: PageTransitionType.rightToLeft));
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8.dg),
                        width: 140.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Colors.white.withOpacity(0.1)),
                        child: Row(
                          children: [
                            const Icon(Icons.theater_comedy_rounded),
                            SizedBox(
                              width: 10.w,
                            ),
                            const Expanded(child: Text("Add Cast"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
