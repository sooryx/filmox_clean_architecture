import 'package:filmox_clean_architecture/presentation/screens/contest/rcMain/RegularContestMainScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/main/dt_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/home/home_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/moviepromotion/movie_promotion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../profile/profile_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  PageController _pageController = PageController();
  final List<Widget> pages = [
    HomeScreen(),
    MoviePromotionScreen(),
    DigitalTheaterMainScreen(),
    RegularContestMainScreen(),
    ProfileScreen(),
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
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        // fixedColor: Colors.red,
        currentIndex: currentPage,
        onTap: onPageChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_rounded),
            label: 'Promotion',
          ), BottomNavigationBarItem(
            icon: Icon(Icons.local_movies_rounded),
            label: 'Theater',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Contest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
