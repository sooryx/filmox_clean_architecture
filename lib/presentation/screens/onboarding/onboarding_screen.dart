import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/presentation/providers/onboarding/onboarding_provider.dart';
import 'package:filmox_clean_architecture/presentation/screens/auth/signin/signin_screen.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController();
  bool lastPage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OnBoardingProvider>(context, listen: false).fetchOnboardingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnBoardingProvider>(
        builder: (context, onboarding, child) {
          switch (onboarding.status) {
            case DefaultPageStatus.loading:
              return const Center(child: Loadingscreen());
            case DefaultPageStatus.failed:
              return const Center(child: Text('Failed to load onboarding data. Please try again.'));
            case DefaultPageStatus.success:
              return
                 Stack(
                  children: [
                    PageView.builder(
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          lastPage = (index == onboarding.onboardingEntity.length - 1);
                        });
                      },
                      itemCount: onboarding.onboardingEntity.length,
                      itemBuilder: (context, index) {

                        String image = onboarding.onboardingEntity[index].image;
                        return introPages(
                          imageUrl: image,
                          context: context,
                        );
                      },
                    ),
                    Container(
                      alignment: const Alignment(0, 0.90),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SmoothPageIndicator(
                            controller: _controller,
                            count: onboarding.onboardingEntity.length,
                            effect: const WormEffect(
                              activeDotColor: Color(0xFF1CB5E0),
                              dotColor: Color(0xFFFFFFFF),
                              dotHeight: 3,
                              dotWidth: 40,
                            ),
                          ),
                          CommonWidgets.gradientButton(
                            context: context,
                            radius: 15,
                            padding: 1,
                            text: lastPage ? 'Done' : 'Skip',
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signinscreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
            case DefaultPageStatus.initial:
            default:
              return const Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }

  Widget introPages({required String imageUrl, required BuildContext context}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF171717),
            Color(0xFF171717),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: "https://filmox.kods.app/uploads/$imageUrl",
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }
}
