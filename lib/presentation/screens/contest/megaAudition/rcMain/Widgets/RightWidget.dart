// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rcFeed/rc_feed_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rcResult/rcResult.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rclive/rc_live_info_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rcRound/mainscreen/rc_round_main_screen.dart';
import 'package:filmox_clean_architecture/widgets/count_down_timer_widget.dart';
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
          return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 10),
              child: Text(
                entry.categoryName,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
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
      splashColor: Theme.of(context).primaryColor,
      enableFeedback: true,
      borderRadius: BorderRadius.circular(15.r),
      onTap: () {
        handleContestNavigation(context, countdownText, currentContest);
      },
      child: currentContest.poster == null
          ? const CircularProgressIndicator()
          : Hero(
              tag: 'bg',
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 900),
                    height: 500.h,
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          currentContest.poster,
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      borderRadius: BorderRadius.circular(
                          8.r), // Ensure radius matches the Material widget
                    ),
                  ),
                  Positioned(
                    bottom: 15.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 140.h,
                      width: double.infinity,
                      child: CountdownText(
                          countdownDuration: countdownDuration,
                          countdownText: countdownText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontFamily: 'Matrixtype',
                                  color: Colors.grey[300]),
                          labeStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[300],
                                  fontSize: 18.sp)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void handleContestNavigation(BuildContext context, String countdownText,
      ContestEntity currentContest) {
    print(countdownText);
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
            contestID: currentContest.contestID,
            contestName: currentContest.name,
          ),
        ),
      );
    } else if (countdownText == "Voting Ended") {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => RCResultMainScreen(
            contestId: currentContest.contestID,
            imageUrl: UrlStrings.imageUrl + (currentContest.poster),
            contestName: currentContest.name,
            isPublished: currentContest.isPublished == 1,
          ),
        ),
      );
    } else if (countdownText == "Rounds Have Started") {
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => RcRoundMainScreen(
            id: currentContest.contestID.toString(),
          )));
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
