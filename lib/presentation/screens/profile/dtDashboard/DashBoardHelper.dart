
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'MultipleFileUpload/AddEpisode.dart';
import 'MultipleFileUpload/EditEpisodePage.dart';
import 'MultipleFileUpload/EditSeasonPage.dart';

class DashBoardHelper {
  ///Season Delete
  void deleteSeasonAlert(
      {required BuildContext context,
      required String? digiID,
      required int seasonID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            "Delete Season",
            style: TextStyle(color: Colors.white),
          ),
          content:
              const Text("Are you sure that you want to delete the season?"),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final dtProvier = Provider.of<DTDashboardProvider>(
                    context,
                    listen: false);
                try {
                  await dtProvier.deleteSeason(digiID: digiID.toString(),seasonID:  seasonID.toString(),);
                } finally {
                  customSuccessToast(context,"Changes saved !!");
                  await  dtProvier.fetchDashboardDetails(digitalTheaterID: digiID.toString());
                  final dtProvider =dtProvier.digitalTheaterDashBoardEntity;
                  Navigator.pop(context,dtProvider);
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteCast(
      {
        required BuildContext context,
        required String digiID,
        required String castName,
        required String role,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            "Delete Cast ?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
              "Are you sure that you want to delete this cast $castName?"),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                showLoadingDialog(
                    context: context,
                    message: "Deleting cast ...",
                    lottie: null);

                try {
                  final dashboardProvider =
                  Provider.of<DTDashboardProvider>(context,
                      listen: false);
                  await dashboardProvider.deleteCastData(
                    context: context,
                    id: digiID ,
                    name: castName,
                    role:role,
                  ).then((value) async{
                    await dashboardProvider.fetchDashboardDetails(digitalTheaterID: digiID);
                  },);
                } catch (e) {
                  customErrorToast(context, "Error:${e.toString()}");
                } finally {
                  final dashboardProvider =
                  Provider.of<DTDashboardProvider>(context,
                      listen: false);
                  Navigator.pop(context,dashboardProvider.digitalTheaterDashBoardEntity);
                  Navigator.pop(context,dashboardProvider.digitalTheaterDashBoardEntity);
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }  void deleteCrew(
      {
        required BuildContext context,
        required String digiID,
        required String crewname,
        required String role,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            "Delete Cast ?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
              "Are you sure that you want to delete this cast $crewname?"),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                showLoadingDialog(
                    context: context,
                    message: "Deleting cast ...",
                    lottie: null);

                try {
                  final dashboardProvider =
                  Provider.of<DTDashboardProvider>(context,
                      listen: false);
                  await dashboardProvider.deleteCrewData(
                    context: context,
                    id: digiID ,
                    name: crewname,
                    role:role,
                  ).then((value) async{
                    await dashboardProvider.fetchDashboardDetails(digitalTheaterID: digiID.toString() );
                  },);
                } catch (e) {
                  customErrorToast(context, "Error:${e.toString()}");
                } finally {
                  final dashboardProvider =
                  Provider.of<DTDashboardProvider>(context,
                      listen: false);
                  Navigator.pop(context,dashboardProvider.digitalTheaterDashBoardEntity);
                  Navigator.pop(context,dashboardProvider.digitalTheaterDashBoardEntity);
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Season Delete
  void deleteEpisodeAlert(
      BuildContext context, int digiID, int seasonID, int episodeID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Delete Season",
            style: TextStyle(color: Colors.white),
          ),
          content:
              const Text("Are you sure that you want to delete the season?"),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<DTDashboardProvider>(
                    context,
                    listen: false);
                await provider.deleteDtEpisode(digiID, seasonID, episodeID);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget popupEpi({
    required BuildContext context,
    required DashboardEpisodeEntity episode,
    required int dtID,
    required int seasonID,
  }) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_horiz_rounded,
        color: Colors.white,
      ),
      elevation: 10,
      color: Theme.of(context).scaffoldBackgroundColor,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Option 1',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit Episode",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: 30.h,
                width: 30.w,
                padding: EdgeInsets.all(5.dg),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.edit,
                  size: 20.sp,
                  color: Colors.blue.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Option 2',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Delete Episode",
                style: TextStyle(color: Colors.white),
              ),
              Container(
                height: 30.h,
                width: 30.w,
                padding: EdgeInsets.all(5.dg),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.delete,
                  size: 20.sp,
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        switch (value) {
          case 'Option 1':
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EditEpisodePage(episode: episode)));
            break;
          case 'Option 2':
            DashBoardHelper()
                .deleteEpisodeAlert(context, dtID, seasonID, episode.id);
            break;
        }
      },
    );
  }

  Widget popupSeas(BuildContext context, int index) {
    return Consumer<DTDashboardProvider>(
      builder: (context, dtProvider, state) {
        return PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
          ),
          elevation: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'Option 1',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Episode",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 30.h,
                    width: 30.w,
                    padding: EdgeInsets.all(5.dg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20.sp,
                      color: Colors.green.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'Option 2',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit Season",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 30.h,
                    width: 30.w,
                    padding: EdgeInsets.all(5.dg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20.sp,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'Option 3',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delete Season",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 30.h,
                    width: 30.w,
                    padding: EdgeInsets.all(5.dg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20.sp,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (String value) {
            switch (value) {
              case 'Option 1':
                  Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => AddEpisodePage(
                                seasonTitle: dtProvider.digitalTheaterDashBoardEntity?.seasons[index].name ??
                                    "NA",
                                seasonID: dtProvider.digitalTheaterDashBoardEntity?.seasons[index].id
                                    .toString() ??
                                    "NA",
                                DigitalTheaterId:dtProvider.digitalTheaterDashBoardEntity?.id.toString() ?? '0',
                              )));
                break;
              case 'Option 2':
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => EditSeasonPage(
                              season: dtProvider.digitalTheaterDashBoardEntity
                                  ?.seasons[index],
                              dtID: dtProvider
                                  .digitalTheaterDashBoardEntity?.id,
                            )));
                break;
              case 'Option 3':
                DashBoardHelper().deleteSeasonAlert(
                    context: context,
                    digiID: dtProvider.digitalTheaterDashBoardEntity?.id.toString(),
                    seasonID: dtProvider.digitalTheaterDashBoardEntity
                        ?.seasons[index].id ??0 );
                break;
            }
          },
        );
      },
    );
  }
}
