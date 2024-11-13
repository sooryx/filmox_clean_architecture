import 'package:filmox/Widgets/custom_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoviePromotionMoreInfoScreen extends StatefulWidget {
  final String bgImage;
  final int index;
  final Widget child;

  const MoviePromotionMoreInfoScreen(
      {super.key, required this.bgImage, required this.index, required this.child});

  @override
  State<MoviePromotionMoreInfoScreen> createState() =>
      _MoviePromotionMoreInfoScreenState();
}

class _MoviePromotionMoreInfoScreenState
    extends State<MoviePromotionMoreInfoScreen> {
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
            leading:  IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 40.sp,
                  color: Theme.of(context).colorScheme.surface),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: widget.child,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SliverPersistentHeaderDelegate(context,
                child: const CustomPageView(), image: widget.bgImage),
          ),
        ],
      ),
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
