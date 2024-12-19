import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/presentation/providers/profile/profile_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/rcMain/RegularContestMainScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/main/dt_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/home/home_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/moviepromotion/mp_main_screen/movie_promotion_main_screen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
 final  PageController _pageController = PageController();

  final List<Widget> pages = [
    const HomeScreen(),
    MoviePromotionScreen(),
    DigitalTheaterMainScreen(),
    const RegularContestMainScreen(),
    const ProfileScreen(),
  ];
  int currentPage = 0;

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: FlashyTabBar(
            backgroundColor: Colors.grey[900],
            selectedIndex: currentPage,
            showElevation: true,
            animationDuration: const Duration(milliseconds: 400),
            onItemSelected: (index) => onPageChanged(index),
            items: [
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: const Icon(
                  Icons.home,
                ),
                title: const Text('Home'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: const Icon(Icons.movie_rounded),
                title: const Text('Promo'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: const Icon(Icons.highlight),
                title: const Text('Theater'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: const Icon(Icons.pages),
                title: const Text('Contest'),
              ),
              FlashyTabBarItem(
                activeColor: Colors.white,
                icon: provider.profileEntity?.profilePhoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: CachedNetworkImage(
                          height: 25.h,
                            width: 25.w,
                            fit: BoxFit.cover,
                            imageUrl: provider.profileEntity!.profilePhoto),
                      )
                    : const Icon(Icons.settings),
                title: const Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
