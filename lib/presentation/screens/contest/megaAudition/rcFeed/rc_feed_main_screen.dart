import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_feed_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'feeds_screens/rc_custom_ads_with_grids.dart';
import 'feeds_screens/rc_feed_list_screen.dart';

class RegularContestFeedMainScreen extends StatefulWidget {
  final int contestID;
  final String contestName;

  const RegularContestFeedMainScreen(
      {super.key, required this.contestID, required this.contestName});

  @override
  State<RegularContestFeedMainScreen> createState() =>
      _RegularContestFeedMainScreenState();
}

class _RegularContestFeedMainScreenState
    extends State<RegularContestFeedMainScreen> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  String errorMessage = '';

  getData() async {
    final provider = Provider.of<RcFeedProvider>(context, listen: false);

    try {
      await provider.fetchContestFeedItems(
          contestID: widget.contestID.toString());
    } on Exception catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    print("Contest Entity  : ${provider.contestFeedEntity}");
    print("Error Message  : ${errorMessage}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<RcFeedProvider>(
        builder: (context, provider, child) {
          if (errorMessage != '') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 60.sp,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(errorMessage),
                ],
              ),
            );
          }
          return RegularContestFeedListScreen(
            items: provider.contestFeedEntity?.contestMedias ?? [],
            index: 0,
            headerWidget: _buildHeaderSection(context),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Consumer<RcFeedProvider>(
      builder: (context, provider, child) {
        variablePrint('''
        Contest Result Entity :
        -----------------
        ${provider.contestFeedEntity?.results}
        ''');
        DateTime now = DateTime.now();
        Duration? duration =
            provider.contestFeedEntity?.endDate.difference(now);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(5.dg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      provider.pageStatus == DefaultPageStatus.loading ||
                              provider.pageStatus == DefaultPageStatus.initial
                          ? SizedBox(
                              height: 100.h,
                              child: const Center(
                                child: Loadingscreen(),
                              ))
                          : _buildListView(provider),
                      CommonWidgets.CustomDivider(
                          start: 5, end: 5, thickness: 2, color: Colors.grey),
                      _buildTimer(countdownDuration: duration!)
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: isSearching ? _buildSearchBox() : _buildIconRow(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconRow() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isSearching = true;
                });
              },
              child: const EmoboseButton(
                icon: Icons.search_rounded,
                text: "Search",
                iconColor: Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                _giftAlertDialog();
              },
              borderRadius: BorderRadius.circular(10.r),
              child: const EmoboseButton(
                icon: Icons.card_giftcard_rounded,
                text: "Gifts",
                iconColor: Colors.deepOrange,
              ),
            ),
            InkWell(
              onTap: () {
                _pointAlertDialog();
              },
              child: const EmoboseButton(
                icon: Icons.workspace_premium_rounded,
                text: "points",
                iconColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 40.h,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                setState(() {
                  isSearching = false;
                });
              },
            ),
          ],
        ),
      ).animate().fade().shimmer(
            duration: const Duration(milliseconds: 600),
          ),
    );
  }

  void _pointAlertDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Lottie.network(
                      'https://lottie.host/9b9aaeb5-a7df-460c-9483-8626680e7bdb/mwSQYpVnBz.json',
                      // Replace with your Lottie animation path
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      repeat: false,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "240 points",
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: Text(
                        textAlign: TextAlign.center,
                        "You will earn 240 points upon reaching 420 votes.",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    width: 120.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "Close",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
    );
  }

  void _giftAlertDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,

      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      // transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              // minHeight: MediaQuery.of(context).size.height * 0.5,
              maxHeight: MediaQuery.of(context).size.height * 0.53,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.network(
                        "https://img.freepik.com/premium-psd/black-friday-banner-template-with-gifts-dark-background-copy-space_154993-1405.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.h,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Black Friday",
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: Text(
                            textAlign: TextAlign.start,
                            " following in UK, Japan, Australia and France.",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15.r)),
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().shake();
      },
    );
  }

  AppBar _buildAppBar() {
    final provider = Provider.of<RcFeedProvider>(context, listen: false);
    return AppBar(
      title: Hero(
        tag: 'bg',
        child: Row(
          children: [
            SizedBox(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      width: 40.w,
                      height: 40.h,
                      imageUrl: provider.contestFeedEntity?.poster ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Image.asset(AppConstants.filmoxLogo);
                      },
                    ))),
            SizedBox(
              width: 10.w,
            ),
            Text(
              widget.contestName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.surface),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            final provider =
                Provider.of<RcFeedProvider>(context, listen: false);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RCCustomGridWithAds(
                    listB: List.generate(2, (index) => 'Ad B$index'),
                    contestInfo: provider.contestFeedEntity,
                  );
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          // icon: Icon(isGrid ? Icons.grid_view_rounded : Icons.view_list_rounded),
          icon: const Icon(
            Icons.apps_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(RcFeedProvider provider) {
    return provider.pageStatus == DefaultPageStatus.failed
        ? const Text("No data ")
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.contestFeedEntity?.results.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    UserEntityContestFeed? user =
                        provider.contestFeedEntity?.results[index];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CachedNetworkImage(
                              height: 50.h,
                              width: 50.w,
                              fit: BoxFit.cover,
                              imageUrl: user?.image ?? '',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          // SizedBox(
                          //   width: 80.w,
                          //   child: Center(
                          //     child: Text(
                          //       profile?.userName ?? "",
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .bodySmall
                          //           ?.copyWith(
                          //               color: Colors.white,
                          //               fontWeight:
                          //                   FontWeight.w200),
                          //       overflow:
                          //           TextOverflow.ellipsis,
                          //       maxLines: 1,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width: 80.w,
                            child: Center(
                              child: Text(
                                user?.totalVotes ?? "",
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const AllPersonsView(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppConstants.allIcon,
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "View All",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )),
              SizedBox(width: 10.w),
            ],
          );
  }

  Widget _buildTimer({required Duration countdownDuration}) {
    return Column(
      children: [
        Text(
          "Voting ends in",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
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
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

class EmoboseButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const EmoboseButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 110.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     // Colors.white.withOpacity(0.35),
        //     // Colors.white.withOpacity(0.15),
        //     Color(0xFF1CB5E0).withOpacity(0.35),
        //     Color(0xFF1CB5E0).withOpacity(0.15),
        //   ],
        // ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: Colors.white,
                // : Colors.grey.shade500
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              icon,
              color: iconColor,
            )
            // Icon(Icons.card_giftcard_sharp, color: Colors.orangeAccent,)
          ],
        ),
      ),
    );
  }
}

class AllPersonsView extends StatelessWidget {
  const AllPersonsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String logo = "https://filmox.kods.app/uploads/uILgWgaL.jpg";

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("All Contestants"),
      ),
      body: Consumer<RcFeedProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.contestFeedEntity?.results.length,
            padding: EdgeInsets.all(10.dg),
            itemBuilder: (context, index) {
              UserEntityContestFeed? user =
                  provider.contestFeedEntity?.results[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  tileColor: Colors.black,
                  leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user?.image ?? logo)),
                  title: Text(
                    user?.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text("Total Votes :${user?.totalVotes.toString()}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
