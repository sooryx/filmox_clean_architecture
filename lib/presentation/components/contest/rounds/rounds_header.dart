// ignore_for_file: unused_import

import 'package:filmox_clean_architecture/presentation/components/contest/rounds/rounds_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundsHeaderPageView extends StatefulWidget {
  final String image;
  final ScrollController scrollController;

  RoundsHeaderPageView(
      {super.key, required this.image, required this.scrollController});

  @override
  State<RoundsHeaderPageView> createState() => _RoundsHeaderPageViewState();
}

class _RoundsHeaderPageViewState extends State<RoundsHeaderPageView> {
  late PageController _pageController;
  ValueNotifier<double> _currentPageNotifier = ValueNotifier<double>(0);

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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
          controller: _pageController,
          children: [
            _buildPage1(context),
            _buildPage2(context),
            _buildPage3(context),
            _buildPage4(context),
          ],
        ),
        Positioned(bottom: 90.h, child: _buildLinearProgressIndicator())
      ],
    );
  }

  Widget _buildPage1(BuildContext context) {
    List<Map<String, dynamic>> iconData = [
      {
        'icon': Icons.highlight,
        'title': 'Highlights',
        'pageIndex': 1,
      },
      {
        'icon': Icons.info_outline,
        'title': 'Promo',
        'pageIndex': 2,
      },
      {
        'icon': Icons.theater_comedy,
        'title': 'Anchor Bit',
        'pageIndex': 3,
      },
    ];
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Container(
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
                  data['icon'],
                  data['title'],
                  data['pageIndex'],
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.dg),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black54.withOpacity(0.6),
                  Colors.black54.withOpacity(0.5),
                  Colors.black54.withOpacity(0.4),
                  Colors.black54.withOpacity(0.3),
                  Colors.black54.withOpacity(0.2),
                ])),
            child: Column(
              children: [
                Text('Unlock the Rhythm of \nMusic!',
                    style: Theme.of(context).textTheme.titleLarge),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => RcRoundInfoScreen()));
                    },
                    child: Hero(
                      tag: 'round',

                      child: Row(
                        children: [
                          Container(
                              height: 15.h,
                              width: 15.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.4)),
                              child: const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.green,
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                           Text("Round #3 is Active Now  ",style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.white.withOpacity(0.5),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "⟢ 346 users are participationg in this competition"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Highlights", style: Theme.of(context).textTheme.titleLarge),
        const Text("Highlights"),
      ],
    );
  }

  Widget _buildPage3(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Promo", style: Theme.of(context).textTheme.titleLarge),
        const Text("Promo"),
      ],
    );
  }

  Widget _buildPage4(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Anchor Bit", style: Theme.of(context).textTheme.titleLarge),
        const Text("Anchor Bit"),
      ],
    );
  }

  Widget _buildIconColumn(
      BuildContext context, IconData icon, String title, int pageIndex) {
    return InkWell(
      enableFeedback: true,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 40.sp),
            SizedBox(height: 5.h),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w100),
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
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          ValueListenableBuilder<double>(
            valueListenable: _currentPageNotifier,
            builder: (context, value, child) {
              int currentPage = ((value * 3).round()) + 1;
              if (currentPage == 1) {
                return const Text("C");
              } else if (currentPage == 2) {
                return const Text("H");
              } else if (currentPage == 3) {
                return const Text("P");
              } else if (currentPage == 4) {
                return const Text("AB");
              } else {
                return const Text("AB");
              }
            },
          ),
        ],
      ),
    );
  }
}
