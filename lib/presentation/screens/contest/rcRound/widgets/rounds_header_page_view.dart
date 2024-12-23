import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/rounds/rounds_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class RoundsHeaderPageView extends StatefulWidget {
  final GlobalKey dataKey;
  final RoundsEntity activeRounds;
  final List<RoundsEntity> allRounds;
  final ScrollController scrollController;
  final bool isVideo;

  const RoundsHeaderPageView({
    Key? key,
    required this.activeRounds,
    required this.scrollController,
    required this.allRounds,
    required this.isVideo, required this.dataKey,
  }) : super(key: key);

  @override
  State<RoundsHeaderPageView> createState() => _RoundsHeaderPageViewState();
}

class _RoundsHeaderPageViewState extends State<RoundsHeaderPageView> {
  late final PageController _pageController;
  final ValueNotifier<double> _currentPageNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      _currentPageNotifier.value = (_pageController.page ?? 0) / 3;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.bottomCenter,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              _buildPageContent(
                context,
                widget.activeRounds.poster,
                widget.activeRounds.title,
              ),
              _buildSimplePage(context, "Highlights"),
              _buildSimplePage(context, "Promo"),
              _buildSimplePage(context, "Anchor Bit"),
            ],
          ),
        ),
        _buildGradientIndicator(),

        Positioned(bottom: 90.h, child: _buildLinearProgressIndicator()),
      ],
    );
  }

  Widget _buildGradientIndicator() {
    return InkWell(
      onTap: () =>
          Scrollable.ensureVisible(widget.dataKey.currentContext!,duration: 800.ms,curve: Curves.easeIn),
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(alignment: Alignment.center,
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text("Scroll to see more", style: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),),
          ).animate().shimmer(duration: 800.ms, delay: 600.ms),
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, String poster, String title) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(UrlStrings.imageUrl + poster),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          _buildIconList(),
          const Spacer(),
          _buildRoundInfo(context, title),
          SizedBox(height: 10.h,)

        ],
      ),
    );
  }

  Widget _buildIconList() {
    final iconData = [
      {'icon': Icons.highlight, 'title': 'Highlights', 'pageIndex': 1},
      {'icon': Icons.info_outline, 'title': 'Promo', 'pageIndex': 2},
      {'icon': Icons.theater_comedy, 'title': 'Anchor Bit', 'pageIndex': 3},
    ];

    return Container(

      margin: EdgeInsets.only(right: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.black54.withOpacity(0.3),
      ),
      width: 130.w,
      child: ListView.builder(
        itemCount: iconData.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final data = iconData[index];
          return _buildIconColumn(
            context,
            data['icon'] as IconData,
            data['title'] as String,
            data['pageIndex'] as int,
          );
        },
      ),
    );
  }

  Widget _buildRoundInfo(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.all(10.dg),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r)

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.activeRounds.roundNumber.toString(),
                style: GoogleFonts.shizuru(fontSize: 60.sp),),
              SizedBox(width: 10.w,),
              Expanded(
                child: Text(title, style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 34.sp)),
              ),
            ],
          ),
          if (widget.activeRounds.isActive)
            _buildParticipationInfo(context),
          SizedBox(height: 20.h),

        ],
      ),
    );
  }

  Widget _buildParticipationInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () => _navigateToRoundPage(context),
        child: Hero(
          tag: 'round',
          child: Row(
            children: [
              Container(
                height: 15.h,
                width: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.4),
                ),
                child: const Icon(Icons.circle, size: 10, color: Colors.green),
              ),
              SizedBox(width: 10.w),
              Text(
                "You can now participate in Round #${widget.activeRounds
                    .roundNumber}",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.white.withOpacity(0.5),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoundPage(BuildContext context) {
    final now = DateTime.now();
    if (now.isAfter(widget.activeRounds.voteDate) &&
        now.isBefore(widget.activeRounds.endDate)) {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) =>
      //         RcRoundFeedScreen(
      //           roundID: widget.activeRounds.roundID.toString(),
      //           contestID: widget.activeRounds.contestID.toString(),
      //           poster: widget.activeRounds.poster,
      //         ),
      //   ),
      // );
    } else if (now.isAfter(widget.activeRounds.endDate)) {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) =>
      //         RcRoundResults(
      //           contestId: widget.activeRounds.contestId.toString(),
      //           roundId: widget.activeRounds.roundId.toString(),
      //         ),
      //   ),
      // );
    } else {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) =>
      //         RoundInfoScreen(
      //           round: widget.activeRounds,
      //           allRound: widget.allRounds,
      //           uploadType: widget.uploadType,
      //         ),
      //   ),
      // );
    }
  }

  Widget _buildSimplePage(BuildContext context, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: Theme
            .of(context)
            .textTheme
            .titleLarge),
        Text(title),
      ],
    );
  }

  Widget _buildIconColumn(BuildContext context, IconData icon, String title,
      int pageIndex) {
    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 40.sp),
            SizedBox(height: 5.h),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinearProgressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          ValueListenableBuilder<double>(
            valueListenable: _currentPageNotifier,
            builder: (context, value, child) {
              return SizedBox(
                height: 2.h,
                width: 350.w,
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey,
                  borderRadius: BorderRadius.circular(20.r),
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
