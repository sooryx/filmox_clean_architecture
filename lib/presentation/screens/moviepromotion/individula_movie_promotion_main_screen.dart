import 'package:expandable_text/expandable_text.dart';
import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'individual_movie_promotion_screen.dart';

class IndividulaMoviePromotionMainScreen extends StatefulWidget {
  final String bgImage;
  final int index;

  const IndividulaMoviePromotionMainScreen(
      {super.key, required this.bgImage, required this.index});

  @override
  State<IndividulaMoviePromotionMainScreen> createState() =>
      _IndividulaMoviePromotionMainScreenState();
}

class _IndividulaMoviePromotionMainScreenState
    extends State<IndividulaMoviePromotionMainScreen> {
  double containerHeight = 230.h;
  PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height - 60,
            snap: true,
            floating: true,
            pinned: false,
            leading: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildBackground(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(context) {
    List<String> title = ['Poster', 'Trailers'];
    List<String> poster = [AppConstants.scareCrow, AppConstants.joker];
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Hero(
                tag: 'bg-image-${widget.index}',
                child: Container(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 40.h,
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.bgImage),
                            fit: BoxFit.cover,
                            opacity: 0.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spider Man",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "Starring Tobey Maguire",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontSize: 16.sp,
                                      color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  "50",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                SizedBox(
                                    height: 40.h,
                                    width: 40.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.orange,
                                      value: 0.5,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.3),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Rating",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontSize: 16.sp,
                                      color: Colors.white.withOpacity(0.8)),
                            )
                          ],
                        )
                      ],
                    )),
              ),
              // Top gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50.h, // Adjust the height as needed
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom gradient

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: containerHeight,
                  // initial height when the text is collapsed
                  alignment: Alignment.bottomCenter,
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(1),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.8),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.7),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon(Icons.favorite_outline_rounded,color: Colors.grey,size: 35.sp,),
                      // SizedBox(height: 10.h,),
                      // Icon(Icons.share,color: Colors.grey,size:35.sp),
                      // SizedBox(height: 10.h,),

                      SizedBox(height: 10.h),
                      ExpandableText(
                        'Spider-Man is a superhero in American comic books published by Marvel Comics. Created by writer-editor Stan Lee and artist Steve Ditko, he first appeared in the anthology comic book Amazing Fantasy #15 in the Silver Age of Comic Books.',
                        expandText: 'Read more',
                        collapseText: 'Show less',
                        maxLines: 3,
                        linkColor: Colors.blue,
                        collapseOnTextTap: true,
                        animation: true,
                        animationCurve: Curves.easeIn,
                        onExpandedChanged: (isExpanded) {
                          // Increase or decrease the height of the container when expanded
                          if (isExpanded) {
                            // Update the height to accommodate the expanded text
                            // You might use a state management solution to trigger a rebuild with the new height
                            setState(() {
                              containerHeight = 320
                                  .h; // Adjust this value based on the content
                            });
                          } else {
                            // Reset the height when collapsed
                            setState(() {
                              containerHeight = 230.h;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: title.length,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => IndividualMoviePromotionScreen(
                                bgImage:
                                    'https://r4.wallpaperflare.com/wallpaper/29/41/144/dunkirk-spitfire-tom-hardy-christopher-nolan-hd-wallpaper-68262de850c0ac38d04cc13ed882e46a.jpg',
                                index: widget.index)));
              },
              child: Hero(
                tag: 'bg-image2-$index',
                child: _buildHorizontalCards(
                    image: poster[index], title: title[index]),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect:
              WormEffect(dotColor: Colors.grey, activeDotColor: Colors.white,dotHeight: 5,dotWidth: 5),
        )
      ],
    );
  }

  Widget _buildHorizontalCards({
    required String image,
    required String title,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.amber[200]),
        ),
        Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width - 125.w,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.grey[850],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      height: 200.h,
                      width: 200.w,
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
