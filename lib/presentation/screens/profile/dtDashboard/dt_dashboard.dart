import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/auth/signin/signin_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/profile/dtDashboard/SingleFileUpload/EditMovieInfo.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'Cast/EditCast.dart';
import 'Crew/EditCrew.dart';
import 'DashBoardHelper.dart';
import 'EditBasicDetailsDT.dart';
import 'MultipleFileUpload/AddSeasons.dart';
import 'SingleFileUpload/EditTrailer.dart';


class DigitaltheaterDashboardScreen extends StatefulWidget {
  final String digitalTheaterID;

  const DigitaltheaterDashboardScreen(
      {super.key, required this.digitalTheaterID});

  @override
  State<DigitaltheaterDashboardScreen> createState() =>
      _DigitaltheaterDashboardScreenState();
}

class _DigitaltheaterDashboardScreenState
    extends State<DigitaltheaterDashboardScreen> {
  void getData() async {
    try {
      final dashboardprovider =
      Provider.of<DTDashboardProvider>(context, listen: false);
      await dashboardprovider.fetchDashboardDetails(
          digitalTheaterID: widget.digitalTheaterID);
    } catch (e) {
      print("Error: ${e.toString()}");
      if (e.toString().contains("Invalid Session")) {
        customErrorToast(context, "Invalid Session");
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => Signinscreen()));

      } else {
        customErrorToast(context, "Error loading data");
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DTDashboardProvider>(
      builder: (context, digitalTheaterProvider, child) {
        final dtProvider = digitalTheaterProvider.digitalTheaterDashBoardEntity;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.surface),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              dtProvider?.title ?? "NA",
            ),
          ),
          body:  digitalTheaterProvider.status == DefaultPageStatus.loading
              ? const Loadingscreen()
              : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            children: [
              Container(
                padding: EdgeInsets.all(10.dg),
                height: 240.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white.withOpacity(0.05)),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: CachedNetworkImage(
                              progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              imageUrl:
                              "${UrlStrings.baseUrl}/uploads/images/${dtProvider?.poster}",
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dtProvider?.title ?? "NA",
                                  style: TextStyle(fontSize: 22.sp),
                                ),
                                SizedBox(height: 5.h),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      dtProvider?.storyLine ?? "NA",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Year  ${dtProvider?.year ?? "NA"}",
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey),
                        ),
                        Text(
                          "Certificate  ${dtProvider?.certificate ?? "NA"}",
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey),
                        ),
                        dtProvider?.id != null
                            ? IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                    const Editbasicdetailsdt()));
                          },
                        )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
              ),
              castcrewandseason(
                  dtId: dtProvider?.id,
                  uploadType: dtProvider?.uploadType ?? 1,
                  castList: dtProvider?.cast,
                  crewList: dtProvider?.crew),
              SizedBox(
                height: 30.h,
              ),
              dtProvider?.uploadType == 1
                  ? singleFileUploadItems(dtProvider)
                  : multiplefileUploadItems(dtProvider?.seasons)
            ],
          ),
        );
      },
    );
  }

  Widget seasonItem(int seasonIndex, List<DashboardSeasonEntity> seasons) {
    return Container(
      padding: EdgeInsets.all(10.dg),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white.withOpacity(0.1)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: seasons[seasonIndex].episodes!.isEmpty
            ? ListTile(
          title: Text(
            "S${seasonIndex + 1}  ${seasons[seasonIndex].name}",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
          trailing: DashBoardHelper().popupSeas(
            context,
            seasonIndex,
          ),
        )
            : ExpansionTile(
          tilePadding: EdgeInsets.zero,
          collapsedTextColor: Colors.green,
          leading: seasons[seasonIndex].episodes!.isEmpty
              ? const SizedBox.shrink()
              : ToggleSwitch(
            customWidths: [80.w, 40.w],
            cornerRadius: 20.r,
            activeBgColors: const [
              [Colors.green],
              [Colors.redAccent]
            ],
            activeFgColor: Colors.white,
            initialLabelIndex:
            seasons[seasonIndex].isPublish,
            inactiveBgColor:
            Theme.of(context).scaffoldBackgroundColor,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['Publish', ''],
            fontSize: 12.sp,
            icons: const [null, Icons.close],
            onToggle: (index) async {
              String publish = index == 0 ? 'Publish' : 'Unpublish';
              try {
                final dtProvider =
                Provider.of<DTDashboardProvider>(
                    context,
                    listen: false);
                await dtProvider.publishSeason(
                    seasonID: seasons[seasonIndex].id.toString());
                customSuccessToast(
                    context,
                    "${'${publish}ed'}:"
                        " ${seasons[seasonIndex].name.toString()}");
              } on Exception {
                customErrorToast(context,
                    "Unable to $publish season: ${seasons[seasonIndex].name.toString()}");
              }
            },
          ),
          title: Text(
            "S${seasonIndex + 1}  ${seasons[seasonIndex].name}",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
          trailing: DashBoardHelper().popupSeas(
            context,
            seasonIndex,
          ),
          children:
          seasons[seasonIndex].episodes?.isEmpty ?? true
              ? []
              : [
            for (var i = 0;
            i <
                seasons[seasonIndex].episodes!
                    .length;
            i++)
              ListTile(
                  onTap: () {},
                  leading: Text(
                    "S${seasonIndex + 1}E${i + 1} ",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16.sp),
                  ),
                  title: Text(
                    seasons[seasonIndex]
                        .episodes?[i].name ??
                        "NA",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: DashBoardHelper().popupEpi(
                      context: context,
                   episode:    seasons[seasonIndex]
                          .episodes![i],
                 seasonID:      seasons[seasonIndex].id,
                     dtID: seasons[seasonIndex].dtId))
          ],
        ),
      ),
    );
  }

  Widget castcrewandseason(
      {required int? dtId,
        required List<DashboardCastEntity>? castList,
        required List<DashboardCastEntity>? crewList,
        required int uploadType
      }) {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EditCast(
                          dtId: widget.digitalTheaterID,
                        )));
              },
              child: Container(
                padding: EdgeInsets.all(12.dg),
                width: 160.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white.withOpacity(0.1)),
                child: Row(
                  children: [
                    Icon(
                      Icons.theater_comedy_rounded,
                      color: Colors.white,
                      size: 35.sp,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: Text(
                          "Edit Casts",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Editcrew(
                          dtId: dtId,
                        )));
              },
              child: Container(
                padding: EdgeInsets.all(12.dg),
                width: 160.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white.withOpacity(0.1)),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 35.sp,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: Text(
                          "Edit Crew",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        uploadType == 1 ?const SizedBox.shrink(): Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AddSeason(
                              dt_id: dtId,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.dg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 35.sp,
                        ),
                        Text(
                          "Add New Season",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ],
    );
  }

  Widget singleFileUploadItems(DtDashboardEntity? dtProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.dg),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r)),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditTrailerInfo(
                        dropDownTrailerType: dtProvider?.trailerType,
                        trailer: dtProvider?.trailerType == "file"
                            ? dtProvider?.trailerMediaFile
                            : dtProvider?.trailerMediaLink,
                        dtId: dtProvider?.id.toString(),
                      )));
            },
            title: const Text(
              "Edit Trailer Info",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Container(
          padding: EdgeInsets.all(10.dg),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r)),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditMovieInfo(
                        dropDownMovieType: dtProvider?.singleMediaType,
                        Movie: dtProvider?.singleMediaType == "file"
                            ? dtProvider?.singleMediaFile
                            : dtProvider?.singleMediaLink,
                        dtId: dtProvider?.id.toString(),
                      )));
            },
            title: const Text(
              "Edit Movie Info",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget multiplefileUploadItems(List<DashboardSeasonEntity>? seasons) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      seasons == []
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/no_json"),
            const Text("No Season Added"),
            SizedBox(
              height: 20.h,
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Seasons",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text("You can manage your uploaded seasons here ",
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),

        // SizedBox(
        //   height: 10.h,
        // ),
        ListView.builder(
          itemCount: seasons?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10.dg),
          itemBuilder: (
              context,
              index,
              ) {
            return Column(
              children: [
                Dismissible(
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {

                    final provider =
                    Provider.of<DTDashboardProvider>(context,
                        listen: false);
                    try {
                      await provider.deleteSeason(
                        digiID:  seasons[index].dtId.toString(),
                        seasonID:
                        seasons[index].id.toString(),
                      );

                    } finally {
                      customSuccessToast(context, "Changes saved !!");

                    }
                  },
                  background: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: UniqueKey(),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: seasonItem(index, seasons!),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
