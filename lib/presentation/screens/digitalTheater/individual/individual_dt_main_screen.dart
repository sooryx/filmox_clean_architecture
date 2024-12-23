import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';
import 'package:filmox_clean_architecture/presentation/components/digitaltheater/individual_video_player.dart';
import 'package:filmox_clean_architecture/presentation/components/digitaltheater/select_season_episode_component.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:filmox_clean_architecture/widgets/youtube_video_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndividualDigitalTheaterScreen extends StatefulWidget {
  final DigitalTheaterEntity digitalTheaterData;
  final bool fromProfile;

  const IndividualDigitalTheaterScreen({
    super.key,
    required this.digitalTheaterData,
    required this.fromProfile,
  });

  @override
  State<IndividualDigitalTheaterScreen> createState() =>
      _IndividualDigitalTheaterScreenState();
}

class _IndividualDigitalTheaterScreenState
    extends State<IndividualDigitalTheaterScreen> {
  bool isCollapsed = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add listener in initState
    _scrollController.addListener(_scrollListener);
    // Precache the background image after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        NetworkImage(
            "${UrlStrings.imageUrl}${widget.digitalTheaterData.poster}"),
        context,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      isCollapsed = _scrollController.offset > 350.h;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.digitalTheaterData.name,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "${UrlStrings.imageUrl}${widget.digitalTheaterData.poster}"),
                fit: BoxFit.cover,
                opacity: 0.1),
          ),
          child: NestedScrollView(
            controller: _scrollController,
            floatHeaderSlivers: true,
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    backgroundColor: Colors.black54.withOpacity(0.2),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isCollapsed ? Colors.blue : Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      widget.fromProfile
                          ? IconButton(
                              icon: Icon(Icons.edit,
                                  color:
                                      isCollapsed ? Colors.blue : Colors.white),
                              onPressed: () {
                                // Navigator.push code here
                              },
                            )
                          : const SizedBox.shrink(),
                      SizedBox(width: 10.w),
                    ],
                    toolbarHeight: 40.h,
                    expandedHeight: 450.h,
                    collapsedHeight: 40.h,
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            buildTop(context,
                                    "${UrlStrings.imageUrl}${widget.digitalTheaterData.poster}")
                                .animate()
                                .fadeIn(duration: 800.ms),
                            if (isCollapsed)
                              ClipRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: AnimatedContainer(
                                    curve: Curves.easeInOut,
                                    duration: Duration(milliseconds: 300),
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ).animate().fadeIn(duration: 800.ms),
                            if (isCollapsed)
                              FlexibleSpaceBar(
                                  stretchModes: const [
                                    StretchMode.zoomBackground
                                  ],
                                  collapseMode: CollapseMode.parallax,
                                  centerTitle: true,
                                  titlePadding: EdgeInsets.only(top: 10.h),
                                  title: Text(widget.digitalTheaterData.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(fontSize: 26.sp))
                                      .animate()
                                      .fadeIn(duration: 800.ms)),
                          ],
                        );
                      },
                    )),
              ];
            },
            body: SingleChildScrollView(
                child: buildContents(
              context: context,
            )),
          ),
        ),
      ),
    );
  }

  Widget buildTop(context, String image) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
    );
  }

  Widget buildContents({
    required context,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.dg),
      child: Column(
        children: [
          details(
            widget.digitalTheaterData.name,
            widget.digitalTheaterData.storyLine,
          ),
          CommonWidgets.CustomDivider(
            color: Colors.white,
            end: 20.w,
            thickness: 1,
            start: 20.w,
          ),
          SizedBox(
            height: 20.h,
          ),
          widget.digitalTheaterData.uploadType == 2
              ? SelectSeasonAndEpisodes(
                  seasons: widget.digitalTheaterData.seasons ,
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            "Watch Trailer",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.sp,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    widget.digitalTheaterData.isTrailerYoutube
                        ? YouTubePlayerWidget(
                            height: 240.h,
                            width: MediaQuery.of(context).size.width,
                            videoUrl: UrlStrings.videoUrl +
                                widget.digitalTheaterData.trailerLink,
                            showControls: true)
                        : VideoPlayerWidget(
                            height: 240.h,
                            width: MediaQuery.of(context).size.width,
                            url: UrlStrings.videoUrl +
                                widget.digitalTheaterData.trailerLink,
                            loadingWidget: Loadingscreen())
                  ],
                ),
          SizedBox(
            height: 10.h,
          ),
          castandCrew(
              widget.digitalTheaterData.cast, widget.digitalTheaterData.crew),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget details(
    String? title,
    String? description,
  ) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text("English · Comedy Drama Series · 3 Seasons",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white.withOpacity(0.5))),
        SizedBox(
          height: 10.h,
        ),
        Text(
          description ?? "",
          textAlign: TextAlign.start,
          softWrap: true,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white),
        ),
        SizedBox(
          height: 20.h,
        ),
        widget.digitalTheaterData.uploadType == 2
            ? const SizedBox.shrink()
            : Column(
                children: [
                    InkWell(
                      onTap: () {
                           Navigator.push(context,
                                       CupertinoPageRoute(builder: (context) => IndividualVideoPlayer(
                                           title: title ?? "",
                                           isYoutube: widget
                                               .digitalTheaterData.isTrailerYoutube,
                                           videoUrl:widget.digitalTheaterData.isTrailerYoutube ? widget.digitalTheaterData.trailerLink : (UrlStrings.videoUrl+widget.digitalTheaterData.trailerLink)
                                       ),));
                      },
                      child: Container(
                        width: 180.w,
                        padding: EdgeInsets.all(8.dg),
                        decoration: BoxDecoration(
                          color: Colors.black54.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_fill_rounded,
                              color: Theme.of(context).colorScheme.surface,
                              size: 25.sp,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              "Watch Now",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              )
      ],
    );
  }

  Widget castandCrew(List<CastEntity> cast, List<CastEntity> crew) {
    return Column(
      children: [
        cast.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  DigitalTheaterCastList(castList: cast)));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            "Cast",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CastAndCrewDisplayWidget(castList: cast),
                  ),
                ],
              ),
        SizedBox(
          height: 20.h,
        ),
        crew.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DigitalTheaterCastList(
                            castList: crew,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            "Crew",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CastAndCrewDisplayWidget(castList: crew),
                  ),
                ],
              ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget CastAndCrewDisplayWidget({
    List<CastEntity>? castList,
    List<CastEntity>? crewList,
  }) {
    final List<CastEntity>? displayList =
        (castList != null && castList.isNotEmpty)
            ? castList
            : (crewList != null && crewList.isNotEmpty)
                ? crewList
                : null;

    // If displayList is null or empty, return an empty container
    if (displayList == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: displayList
          .map(
            (castMember) => Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Container(
                padding: EdgeInsetsDirectional.all(3.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: CachedNetworkImageProvider(
                          UrlStrings.imageUrl + castMember.image,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: SizedBox(
                        width: 110.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              castMember.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            Text(
                              castMember.role,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DigitalTheaterCastList extends StatefulWidget {
  final List<CastEntity> castList;

  const DigitalTheaterCastList({super.key, required this.castList});

  @override
  State<DigitalTheaterCastList> createState() => _DigitalTheaterCastListState();
}

class _DigitalTheaterCastListState extends State<DigitalTheaterCastList> {
  bool startAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Casts",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        primary: false,
        shrinkWrap: true,
        itemCount: widget.castList.length,
        itemBuilder: (context, index) {
          return item(index);
        },
      ),
    );
  }

  Widget item(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500 + (index * 200)),
      transform:
          Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          padding: EdgeInsetsDirectional.all(3.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.r),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35.r,
                        backgroundImage: NetworkImage(
                            UrlStrings.imageUrl + widget.castList[index].image),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 220.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.castList[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                        Text(
                          widget.castList[index].role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
