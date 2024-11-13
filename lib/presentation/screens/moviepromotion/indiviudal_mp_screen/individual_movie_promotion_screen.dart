import 'package:expandable_text/expandable_text.dart';
import 'package:filmox/Constants/images.dart';
import 'package:filmox/Screens/Entrypoint/bottomnavscreens/moviepromotion/components/movie_promotion_more_info_screen.dart';
import 'package:filmox/screens/Loadingscreen/loadingscreen.dart';
import 'package:filmox/widgets/CustomVideoPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndividualMoviePromotionScreen extends StatefulWidget {
  final String bgImage;
  final int index;

  const IndividualMoviePromotionScreen(
      {super.key, required this.bgImage, required this.index});

  @override
  State<IndividualMoviePromotionScreen> createState() =>
      _IndividualMoviePromotionScreenState();
}

class _IndividualMoviePromotionScreenState
    extends State<IndividualMoviePromotionScreen> {
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
            leading:  IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 40.sp,
                  color: Theme.of(context).colorScheme.surface),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(

              background: _buildBackground(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(context) {
    List<String> title = ['Poster', 'Trailers', 'Audio Launch'];
    List<String> poster = [
      AssetImages.scareCrow,
      AssetImages.joker,
      AssetImages.robo
    ];
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 40.w,),
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
                        Spacer(),
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
                handleNavigation(title[index], index);
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
          count: title.length,
          effect: const WormEffect(
              dotColor: Colors.grey,
              activeDotColor: Colors.white,
              dotHeight: 5,
              dotWidth: 5),
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
                  const Spacer(),
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

  void handleNavigation(String title, int index) {
    if (title == 'Poster') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => MoviePromotionMoreInfoScreen(
                  bgImage: widget.bgImage, index: widget.index,
                  child: _posterBackgroundWidget(context),
              )
          ));
    } else if (title == 'Trailers') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => MoviePromotionMoreInfoScreen(
                bgImage: widget.bgImage, index: widget.index,
                child: _trailerBackgroundWidget(context),
              )
          ));
    } else if (title == 'Audio Launch') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => MoviePromotionMoreInfoScreen(
                bgImage: widget.bgImage, index: widget.index,
                child: _audioLaunchBackgroundWidget(context),
              )
          ));
    }
  }
  Widget _posterBackgroundWidget(context) {
    return Stack(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 40.w,),

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
                  Spacer(),
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
                                backgroundColor: Colors.grey.withOpacity(0.3),
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
          bottom: 40,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 250.h,
            // initial height when the text is collapsed
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_outline_rounded,color: Colors.grey,size: 35.sp,),
                        SizedBox(height: 10.h,),
                        Icon(Icons.share,color: Colors.grey,size:35.sp),
                        SizedBox(height: 10.h,),

                        SizedBox(height: 10.h),

                      ],
                    ),

                  ],
                ),
               SizedBox(height: 10.h,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(children: [
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

                   ],),
                   Container(
                     width: 140.w,
                     height: 45.h,
                     alignment: Alignment.center,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30.r),
                       color: Colors.white,
                     ),
                     child: Row(
                       children: [
                         SizedBox(width: 10.w),
                         const Icon(Icons.movie_filter_sharp),
                         SizedBox(width: 10.w),
                         Text(
                           "Get Tickets",
                           style: Theme.of(context)
                               .textTheme
                               .headlineMedium
                               ?.copyWith(
                             color: Colors.black,
                             fontSize: 16.sp,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         SizedBox(width: 10.w),
                       ],
                     ),
                   )


                 ],
               )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _trailerBackgroundWidget(context) {
    return Stack(
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
                      opacity: 0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 40.w,),
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
                  const Spacer(),
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
                                backgroundColor: Colors.grey.withOpacity(0.3),
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
        Positioned(
          top: 0,
          left: 5,
          right: 5,
          bottom: 0,
          child:  Center(child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: VideoPlayerWidget(
              height: 250.h,
              width: 250.w, url: 'https://videos.pexels.com/video-files/7649294/7649294-uhd_1440_2560_30fps.mp4', loadingWidget: const Loadingscreen(),
            ),
          )),),
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
          bottom: 30,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: containerHeight,
            // initial height when the text is collapsed
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite_outline_rounded,color: Colors.grey,size: 35.sp,),
                SizedBox(height: 10.h,),
                Icon(Icons.share,color: Colors.grey,size:35.sp),
                SizedBox(height: 10.h,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Directed by,',
                        style: TextStyle(fontSize: 16.sp),
                        children: [
                          TextSpan(
                            text: '\nChristopher Nolan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 140.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10.w),
                          const Icon(Icons.movie_filter_sharp),
                          SizedBox(width: 10.w),
                          Text(
                            "Get Tickets",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                ExpandableText(
                  'Spider-Man is a superhero in American comic books published by Marvel Comics. Created by writer-editor Stan Lee and artist Steve Ditko, he first appeared in the anthology comic book Amazing Fantasy #15 in the Silver Age of Comic Books.',
                  expandText: 'Read more',
                  collapseText: 'Show less',
                  maxLines: 1,
                  linkColor: Colors.blue,
                  collapseOnTextTap: true,animation: true,
                  animationCurve: Curves.easeIn,
                  onExpandedChanged: (isExpanded) {
                    // Increase or decrease the height of the container when expanded
                    if (isExpanded) {
                      // Update the height to accommodate the expanded text
                      // You might use a state management solution to trigger a rebuild with the new height
                      setState(() {
                        containerHeight =
                            320.h; // Adjust this value based on the content
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
    );
  }

  Widget _audioLaunchBackgroundWidget(context) {
    return Stack(
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
                      opacity: 0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 40.w,),
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
                  const Spacer(),
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
                                backgroundColor: Colors.grey.withOpacity(0.3),
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
        Positioned(
          top: 0,
          left: 5,
          right: 5,
          bottom: 0,
          child:  Center(child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: VideoPlayerWidget(
              height: 250.h,
              width: 250.w, url: 'https://videos.pexels.com/video-files/7649294/7649294-uhd_1440_2560_30fps.mp4', loadingWidget: const Loadingscreen(),
            ),
          )),),
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
          bottom: 30,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: containerHeight,
            // initial height when the text is collapsed
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite_outline_rounded,color: Colors.grey,size: 35.sp,),
                SizedBox(height: 10.h,),
                Icon(Icons.share,color: Colors.grey,size:35.sp),
                SizedBox(height: 10.h,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Directed by,',
                        style: TextStyle(fontSize: 16.sp),
                        children: [
                          TextSpan(
                            text: '\nChristopher Nolan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 140.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10.w),
                          const Icon(Icons.movie_filter_sharp),
                          SizedBox(width: 10.w),
                          Text(
                            "Get Tickets",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                ExpandableText(
                  'Spider-Man is a superhero in American comic books published by Marvel Comics. Created by writer-editor Stan Lee and artist Steve Ditko, he first appeared in the anthology comic book Amazing Fantasy #15 in the Silver Age of Comic Books.',
                  expandText: 'Read more',
                  collapseText: 'Show less',
                  maxLines: 1,
                  linkColor: Colors.blue,
                  collapseOnTextTap: true,animation: true,
                  animationCurve: Curves.easeIn,
                  onExpandedChanged: (isExpanded) {
                    // Increase or decrease the height of the container when expanded
                    if (isExpanded) {
                      // Update the height to accommodate the expanded text
                      // You might use a state management solution to trigger a rebuild with the new height
                      setState(() {
                        containerHeight =
                            320.h; // Adjust this value based on the content
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
    );
  }


}
