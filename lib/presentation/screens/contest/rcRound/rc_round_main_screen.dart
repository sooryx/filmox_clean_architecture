import 'package:filmox_clean_architecture/presentation/components/contest/rounds/rounds_cards.dart';
import 'package:filmox_clean_architecture/presentation/components/contest/rounds/rounds_header.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RcRoundMainScreen extends StatefulWidget {
  const RcRoundMainScreen({super.key});

  @override
  State<RcRoundMainScreen> createState() => _RcRoundMainScreenState();
}

class _RcRoundMainScreenState extends State<RcRoundMainScreen> {
  ScrollController _scrollController = ScrollController();
  String image =
      'https://c4.wallpaperflare.com/wallpaper/935/17/266/eminem-computer-desktop-backgrounds-wallpaper-preview.jpg';

  double _overlayOpacity = 1.0; // Start with full opacity
  bool _isScrolled = false; // To check if scrolling has occurred

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 10;
        _overlayOpacity = _isScrolled ? 0.0 : 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(image), opacity: 0.1, fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Scrollbar(
              radius: Radius.circular(20.r),
              controller: _scrollController,
              thickness: 10,
              interactive: true,
              thumbVisibility: true,
              child: NestedScrollView(
                controller: _scrollController,
                floatHeaderSlivers: true,
                physics: PageScrollPhysics(),
                dragStartBehavior: DragStartBehavior.down,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      toolbarHeight: 20.h,
                      expandedHeight: MediaQuery.of(context).size.height - 80.h,
                      collapsedHeight: 250.h,
                      leading: const SizedBox.shrink(),
                      floating: true,
                      pinned: false,
                      snap: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: RoundsHeaderPageView(
                          image: image,
                          scrollController: _scrollController,
                        ),
                        collapseMode: CollapseMode.pin,
                        centerTitle: true,
                      ),
                    ),
                  ];
                },
                body: _buildContent(context),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 0,
              right: 0,
              child: Visibility(
                  visible: !_isScrolled, child: _buildOverlay(context)),
            ) // The overlay widget
          ],
        ),
      ),
    );
  }
  void _scrollToSeeMore() {
    print("object");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  Widget _buildOverlay(BuildContext context) {
    return AnimatedOpacity(
      opacity: _overlayOpacity,
      duration: const Duration(milliseconds: 300),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            _scrollToSeeMore();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            margin: EdgeInsets.only(bottom: 40.h),
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "Tap here to see rounds",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ).animate(autoPlay: true,delay: 300.ms).shimmer(delay: 600.ms,duration: 800.ms,color: Theme.of(context).primaryColor,),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonWidgets.CustomDivider(
              start: 10, end: 10, thickness: 5, color: Colors.white),
          _buildRounds(context),
        ],
      ),
    );
  }

  Widget _buildRounds(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(10.dg),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.black54.withOpacity(0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rounds",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.h),
            _buildRoundsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundsList(BuildContext context) {
    return ListView.builder(
      itemCount: rounds.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => RoundsBanner(
        title: rounds[index]["title"]!,
        remainingDays: rounds[index]["remainingDays"]!,
        description: rounds[index]["description"]!,
        color: Colors.white.withOpacity(0.1),
        index: index + 1,
        isCompleted: rounds[index]["isCompleted"] == "true",
      ),
    );
  }

  List<Map<String, String>> rounds = [
    {
      "title": "Beethoven's Battle",
      "remainingDays": "5",
      "description":
          "A symphonic showdown, where classical music meets modern rhythm. Will you survive the clash of eras?",
      "isCompleted": "true"
    },
    {
      "title": "Mozart's Melody",
      "remainingDays": "3",
      "description":
          "A melodic journey through the genius of Mozart. Can you keep up with his intricate compositions?",
      "isCompleted": "true"
    },
    {
      "title": "Jazz Jam",
      "remainingDays": "7",
      "description":
          "Dive into the smooth sounds of jazz. How well can you improvise with the rhythm of the night?",
      "isCompleted": "false"
    },
    {
      "title": "Rock Revolution",
      "remainingDays": "4",
      "description":
          "The electric energy of rock awaits. Can you handle the thunderous riffs and epic solos?",
      "isCompleted": "false"
    },
    {
      "title": "Pop Pulse",
      "remainingDays": "2",
      "description":
          "Feel the beat of today’s pop hits. Stay on rhythm and vibe with the latest chart-toppers.",
      "isCompleted": "true"
    },
  ];
}
