import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/presentation/providers/contest/megaAudition/rc_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rcRound/mainscreen/rc_round_main_screen.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'rc_individual_screen.dart';

class RegularContestMainScreen extends StatefulWidget {
  const RegularContestMainScreen({super.key});

  @override
  _RegularContestMainScreenState createState() =>
      _RegularContestMainScreenState();
}

class _RegularContestMainScreenState extends State<RegularContestMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox.shrink(),
        title: const Text('Regular Contest'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: SizedBox(
            height: 60.h,
            width: 380.w,
            child: TabBar(
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                // Use the default focused overlay color
                return states.contains(WidgetState.focused)
                    ? null
                    : Colors.transparent;
              }),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              isScrollable: false,
              enableFeedback: true,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              indicatorWeight: 10,
              indicator: BoxDecoration(
                  color: null,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.35),
                      Theme.of(context).primaryColor.withOpacity(0.15),
                    ],
                  )),
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 24.sp),
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18.sp),
              tabs: const [
                Tab(text: 'Live'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Finished'),
              ],
            ),
          ),
        ),

      ),
      body: Consumer<RcMainProvider>(
        builder: (context, provider, child) {
          return provider.status == DefaultPageStatus.initial || provider.status == DefaultPageStatus.loading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.h),
                    child: const Loadingscreen(),
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  dragStartBehavior: DragStartBehavior.start,
                  viewportFraction: 1,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    RCIndividualPage(
                      data: provider.liveContests,
                    ),
                    RCIndividualPage(
                        data:provider.upcomingContests),
                    RCIndividualPage(
                        data: provider.finishedContests,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
