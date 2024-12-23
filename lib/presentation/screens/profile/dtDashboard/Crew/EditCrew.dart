import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/profile/dtDashboard/DashBoardHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'AddCrew.dart';
import 'EditIndividualCrew.dart';

class Editcrew extends StatefulWidget {
  final int? dtId;

  const Editcrew({super.key, this.dtId});

  @override
  State<Editcrew> createState() => _EditcrewState();
}

class _EditcrewState extends State<Editcrew> {
  final List<TextEditingController> _nameControllerscrew = [];
  final List<TextEditingController> _roleControllerscrew = [];
  final List<File?> _imageFilescrew = [];
  final List<bool> _isNewcrew = [];

  @override
  void initState() {
    super.initState();
    _initializeControllersAndFiles();
  }

  void _initializeControllersAndFiles() {
    _nameControllerscrew.clear();
    _roleControllerscrew.clear();
    _imageFilescrew.clear();
    _isNewcrew.clear();
    final dashboardProvider =
        Provider.of<DTDashboardProvider>(context, listen: false);
    final crew = dashboardProvider.digitalTheaterDashBoardEntity?.cast;
    crew?.forEach((crewMember) {
      _nameControllerscrew.add(TextEditingController(text: crewMember.name));
      _roleControllerscrew.add(TextEditingController(text: crewMember.role));
      _imageFilescrew.add(null);
      _isNewcrew.add(false); // Existing crew members are not new
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Crew Information'),
          actions: [
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
            SizedBox(width: 10.w),
          ],
        ),
        body: Consumer<DTDashboardProvider>(
          builder: (context, dtProvider, state) {
            final crew = dtProvider.digitalTheaterDashBoardEntity?.crew;
            return SingleChildScrollView(
              child: Column(
                children: [
                  crew!.isNotEmpty
                      ? ListView.builder(
                          itemCount: crew.length,
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
                              onDismissed: (direction) {
                                DashBoardHelper().deleteCrew(
                                    context: context,
                                    digiID: dtProvider
                                        .digitalTheaterDashBoardEntity?.id.toString() ?? '0',
                                    crewname: crew[index].name,
                                    role: crew[index].role);
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: EditIndividualCrew(
                                            nameController:
                                                TextEditingController(
                                                    text: crew[index].name),
                                            roleController:
                                                TextEditingController(
                                                    text: crew[index].role),
                                            imgFile: crew[index].image,
                                            id: crew[index].id ?? 0,
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
                                              '${UrlStrings.imageUrl}${crew[index].image}',
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
                                            crew[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp),
                                          ),
                                          Text(
                                            crew[index].role,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.sp),
                                          ),
                                        ],
                                      )),
                                      InkWell(
                                        onTap: () {
                                          DashBoardHelper().deleteCrew(
                                              context: context,
                                              digiID: dtProvider
                                                  .digitalTheaterDashBoardEntity
                                                  ?.id.toString() ?? '0',
                                              crewname: crew[index].name,
                                              role: crew[index].role);
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
                          height: crew.isNotEmpty ? 20.h : 350.h,
                        ),
                  crew.isEmpty
                      ? const Text(
                          textAlign: TextAlign.center,
                          "No data available, Tap the button below to add new crew members")
                      : const SizedBox.shrink(),
                  crew.isEmpty
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
                              child: AddCrew(
                                dtID: widget.dtId ?? 0,
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
                            const Expanded(child: Text("Add crew"))
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
