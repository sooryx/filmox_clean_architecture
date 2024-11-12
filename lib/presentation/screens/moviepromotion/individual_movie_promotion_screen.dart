import 'package:expandable_text/expandable_text.dart';
import 'package:filmox_clean_architecture/presentation/components/moviepromotion/custom_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final ScrollController _scrollController = ScrollController();
  double containerHeight = 230.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height,
            snap: true,
            floating: true,
            pinned: false,
            leading: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildBackground(context),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SliverPersistentHeaderDelegate(context,
                child: CustomPageView(), image: widget.bgImage),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(context) {
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

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final BuildContext context;
  final String image;

  _SliverPersistentHeaderDelegate(this.context,
      {required this.child, required this.image});

  @override
  double get minExtent => 200;

  @override
  double get maxExtent => MediaQuery.of(context).size.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(image), fit: BoxFit.cover, opacity: 0.05)),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
