import 'package:filmox_clean_architecture/presentation/components/entrypoint/custom_bottom_navbar.dart';
import 'package:filmox_clean_architecture/presentation/screens/contest/megaAudition/rcMain/rc_mega_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/digitalTheater/main/dt_main_screen.dart';
import 'package:filmox_clean_architecture/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  PageController _pageController = PageController();
  final List<Widget> pages = [
    HomeScreen(),
    DigitalTheaterMainScreen(),
    RegularContestMainScreen(),
    const Center(child: Text('Settings Page')),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            top: 0,
            child: MenuTabBar(
              background:Theme.of(context).primaryColor.withOpacity(0.1),
              iconButtons: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController.animateToPage(0,
                        duration: 300.ms, curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController.animateToPage(1,
                        duration: 300.ms, curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController.animateToPage(2,
                        duration: 300.ms, curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _pageController.animateToPage(3,
                        duration: 300.ms, curve: Curves.easeInOut);
                    // Action for settings button
                  },
                ),
              ],
              colorMenuIconActivated: Colors.black54,
              colorMenuIconDefault: Theme.of(context).primaryColor,
              backgroundMenuIconActivated: Colors.white,
              backgroundMenuIconDefault: Colors.white,
              // Main content for the screen goes here
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Digital Theater",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h,),
                  Text(
                    "Main Content",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h,),

                  Text(
                    "Main Content",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}