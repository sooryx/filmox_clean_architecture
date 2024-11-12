import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'CricketDetailedScreen.dart';

class CricketDashboard2 extends StatefulWidget {
  const CricketDashboard2({super.key});

  @override
  State<CricketDashboard2> createState() => _CricketDashboard2State();
}

class _CricketDashboard2State extends State<CricketDashboard2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200), // Animation duration
      vsync: this,
    );

    // Slide from left for Team 1
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0), // Offscreen left
      end: Offset.zero, // Onscreen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Smooth entry curve
    ));

    // Slide from right for Team 2
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0), // Offscreen right
      end: Offset.zero, // Onscreen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Fade-in effect for both teams
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Smooth fade-in
    ));

    // Shake animation: oscillates back and forth
    _shakeAnimation = Tween<double>(begin: 0, end: 6.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

    // Scale animation: scale from 0.5 to 1.0
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Start the animation once the screen is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width ;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://konexionetwork.com/Content/News/rcb-vs-mi-match-at-m-chinnaswamy.jpg",
                ),
              ),
            ),
          ),
          // Gradient at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight *
                  0.35, // Adjust the height of the gradient section
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Team 1 Logo and Name with Slide, Shake, Fade, and Scale
                        SlideTransition(
                          position: _leftSlideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Transform.translate(
                              offset: Offset(_shakeAnimation.value,
                                  0), // Apply shake effect
                              child: ScaleTransition(
                                scale: _scaleAnimation, // Apply scale effect
                                child: Row(
                                  children: [
                                    Image.network(
                                      'https://icon2.cleanpng.com/20240218/fb/transparent-cricket-cricket-batsman-cricket-player-white-unifo-cricket-player-in-white-uniform-hits-1710873995732.webp',
                                      height: 40,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'RCB',
                                      style:GoogleFonts.piedra(fontSize: 36.sp,fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Center: VS Text with Fade-In
                        FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation, // Apply scale effect
                            child: Text(
                              'VS',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        // Right side: Team 2 Logo and Name with Slide, Shake, Fade, and Scale
                        SlideTransition(
                          position: _rightSlideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Transform.translate(
                              offset: Offset(_shakeAnimation.value,
                                  0), // Apply shake effect
                              child: ScaleTransition(
                                scale: _scaleAnimation, // Apply scale effect
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      'https://icon2.cleanpng.com/20240218/fb/transparent-cricket-cricket-batsman-cricket-player-white-unifo-cricket-player-in-white-uniform-hits-1710873995732.webp',
                                      height: 40,

                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'MI',
                                        style:GoogleFonts.piedra(fontSize: 36.sp,fontWeight: FontWeight.bold)

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CommonWidgets.customButton(
                      context: context,
                      icon: Icons.play_arrow,
                      text: "Watch",
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const Cricketdetailedscreen(),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
