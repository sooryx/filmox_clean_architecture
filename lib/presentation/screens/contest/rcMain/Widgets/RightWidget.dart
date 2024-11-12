import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/contest_entity.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rcFeed/rc_feed_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rclive/rc_live_info_screen.dart';
import 'package:filmox_clean_architecture/providers/contest/rc_main_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RightWidget extends StatelessWidget {
  final TabController? tabController;
  final List<ContestEntity> data;
  final PageController? pageController;

  const RightWidget(
      {super.key, this.tabController, required this.data, this.pageController});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildLoadingWidget(context);
    } else {
      return PageView.builder(
        scrollDirection: Axis.vertical,
        controller: pageController,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var entry = data[index];
          return ListView(padding: EdgeInsets.zero, children: [
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0,bottom: 10),
            //   child: Text(
            //     entry.categoryName,
            //     textAlign: TextAlign.end,
            //     style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            //   ),
            // ),
            _buildPost(entry, context)
          ]);
        },
      );
    }
  }

  Widget _buildLoadingWidget(context) {
    return Center(
      child: InkWell(
        onTap: () async {
          final provider = Provider.of<RcMainProvider>(context, listen: false);
          await provider.fetchContests();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("No Upcoming contests available as of now "),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.surface,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Tap to refresh",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(ContestEntity currentContest, BuildContext context) {
    final countdownDetails = getCountdownDetails(currentContest);
    final Duration countdownDuration = countdownDetails['countdownDuration'];
    final String countdownText = countdownDetails['countdownText'];
    return InkWell(
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      enableFeedback: true,
      borderRadius: BorderRadius.circular(30.r),
      onTap: () {
        handleContestNavigation(context, countdownText, currentContest);
      },
      child: Hero(
        tag: 'bg',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          height: 500.h,
          margin: EdgeInsets.only(bottom: 15.h, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.r)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                currentContest.poster,
              ),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180.h,
              padding: EdgeInsets.all(10.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r),
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentContest.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 22.sp,
                        ),
                  ),
                  if (countdownDuration > Duration.zero)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        countdownDuration.inDays != 0
                            ? CommonWidgets.CustomNeumorphicTimer(
                                context: context,
                                duration: countdownDuration,
                                height: 60.h,
                                width: 60.h,
                                isDay: true,
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          width: 8.w,
                        ),
                        countdownDuration.inHours != 0
                            ? CommonWidgets.CustomNeumorphicTimer(
                                context: context,
                                duration: countdownDuration,
                                height: 60.h,
                                width: 60.h,
                                isHour: true)
                            : const SizedBox.shrink(),
                        SizedBox(
                          width: 8.w,
                        ),
                        countdownDuration.inMinutes != 0
                            ? CommonWidgets.CustomNeumorphicTimer(
                                context: context,
                                duration: countdownDuration,
                                height: 60.h,
                                width: 60.h,
                                isMinute: true)
                            : const SizedBox.shrink(),
                        SizedBox(
                          width: 8.w,
                        ),
                        countdownDuration.inSeconds != 0
                            ? CommonWidgets.CustomNeumorphicTimer(
                                context: context,
                                duration: countdownDuration,
                                height: 60.h,
                                width: 60.h,
                                isSecond: true,
                                onDone: () {
                                  final provider = Provider.of<RcMainProvider>(
                                      context,
                                      listen: false);
                                  provider.fetchContests();
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  Text(
                    countdownText,
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleContestNavigation(BuildContext context, String countdownText,
      ContestEntity currentContest) {
    if (countdownText == "Voting Starts In" ||
        countdownText == "Contest Starts In") {
      Navigator.push(
        context,
        CupertinoPageRoute(
          allowSnapshotting: true,
          builder: (context) => RcLiveInfoScreen(
            currentItemContest: currentContest,
          ),
        ),
      );
    } else if (countdownText == "Voting Ends In") {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => RegularContestFeedMainScreen(
            contestID: currentContest.contestID ,
            contestName: currentContest.name ,
          ),
        ),
      );
    } else if (countdownText == "Voting Ended") {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => RCResultMainScreen(
      //       contestId: currentContest.contestID ?? 0,
      //       imageUrl: UrlStrings.imageUrl+(currentContest.poster ?? ""),
      //       contestName: currentContest.title ?? "",
      //       isPublished: currentContest.is_published == 1,
      //       // contestID: currentContest.id ?? 0,
      //       // contestName: currentContest.title ?? "",
      //     ),
      //   ),
      // );
    }
  }

  Map<String, dynamic> getCountdownDetails(ContestEntity currentContest) {
    DateTime startTime = currentContest.startDate;
    DateTime voteStartTime = currentContest.voteDate;
    DateTime endDate = currentContest.endDate;
    DateTime now = DateTime.now();
    Duration countdownDuration;
    String countdownText;

    // print(
    //     "Start Time : $startTime \n VoteStartTime: $voteStartTime \n Enddate: $endDate");

    if (now.isBefore(startTime)) {
      countdownDuration = startTime.difference(now);
      countdownText = "Contest Starts In";
    } else if (now.isBefore(voteStartTime)) {
      countdownDuration = voteStartTime.difference(now);
      countdownText = "Voting Starts In";
    } else if (now.isBefore(endDate)) {
      countdownDuration = endDate.difference(now);
      countdownText = "Voting Ends In";
    } else {
      countdownDuration = Duration.zero;
      countdownText = "Voting Ended";
    }

    return {
      'countdownDuration': countdownDuration,
      'countdownText': countdownText,
    };
  }
}
