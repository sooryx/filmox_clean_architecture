// ignore_for_file: dead_code

import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/domain/entity/profile/profile_entity.dart';
import 'package:filmox_clean_architecture/presentation/providers/profile/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gallery_3d/gallery3d.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'dtDashboard/dt_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late Gallery3DController controller;

  final PageController pageController = PageController();
  final double coverHeight = 420.h;
  final double profileHeight = 100.h;
  late final TabController tabController;
  int selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);

    controller = Gallery3DController(
        itemCount: 6,
        autoLoop: true,
        delayTime: 2000); // Initialize the controller here
  }

  void _handleTabChange() {
    setState(() {
      selectedIndex = tabController.index;
      _pageController.animateToPage(selectedIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    String logo = "https://filmox.kods.app/uploads/uILgWgaL.jpg";
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final profileData = provider.profileEntity;
        return Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              List<String> coverImages = provider.profileEntity?.coverPictures ?? [];
              return [
                appbar(
                    profileData.name,
                    profileData.profession,
                    profileData.industry,
                    profileData.profilePhoto,
                    coverImages)
              ];
            },
            body: buildContents(
                image: profileData?.profilePhoto ?? logo, dt: profileData!.digitalTheater ),
          ),
        );
      },
    );
  }

  Widget buildContents(
      {required String image, required List<DigitalTheatreProfileEntity> dt}) {
    List<String> itemName = ['Media', 'Digital Theater', 'Events'];
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(

              image: NetworkImage(
                  'https://as1.ftcdn.net/v2/jpg/06/01/48/24/1000_F_601482476_FX47F1UANQTfYA7eUp9dfBcWGJ1tbAVO.jpg'),
              fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30,sigmaY: 30),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),

          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 120.w,
                        padding: EdgeInsets.all(5.dg),
                        decoration: BoxDecoration(
                            color: const Color(0xFF1CB5E0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people,color: Colors.white,),
                            SizedBox(
                              width: 8.h,
                            ),
                            const Text('Follow'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          width: 120.w,
                          padding: EdgeInsets.all(5.dg),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1CB5E0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat,color: Colors.white,),
                              SizedBox(
                                width: 8.h,
                              ),
                              const Text('Chat'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.dg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1CB5E0).withOpacity(0.1),
                    ),
                    child: const Icon(Icons.settings),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.dg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '28',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.sp, color: Colors.white),
                        ),
                        Text(
                          'Media',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.5),
                      height: 60.h,
                      width: 1.w,
                    ),
                    Column(
                      children: [
                        Text(
                          '125K',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.sp),
                        ),
                        Text(
                          'Followers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.5),
                      height: 60.h,
                      width: 1.w,
                    ),
                    Column(
                      children: [
                        Text(
                          '323',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.sp),
                        ),
                        Text(
                          'Following',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                // padding: EdgeInsets.all(8.dg),
                height: 60.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50.r),
                  // color: Colors.white.withOpacity(.3),
                ),
                child: Center(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: itemName.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        List<String> itemName = [
                          'Media',
                          'Digital Theater',
                          'Events'
                        ];
                        List<IconData> itemIcon = [
                          Icons.movie_creation_outlined,
                          Icons.theater_comedy_rounded,
                          Icons.event,
                        ];
                        return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Center(
                              child: MyListItem(
                                  isSelected: selectedIndex == index,
                                  iconData: itemIcon[index],
                                  text: itemName[index]),
                            ));
                      }),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.all(10.dg),
                height: dt.isNotEmpty ? 150.h * dt.length.toDouble() : 340.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: itemName.length,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                      tabController.index = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (selectedIndex == 0) {
                      return mediaPageview1();
                    }
                    if (selectedIndex == 1) {
                      return digitalTheaterPageview2(dt);
                    }
                    if (selectedIndex == 2) {
                      return eventsPageview3();
                    }
                    return null;
                  },
                  pageSnapping: true,
                  // Enable page snapping for smoother animation
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCoverImage(
      final String name,
      final String profession,
      final String industry,
      List<String> coverImages,
      ) {
    double progress = (_currentPage + 1) / coverImages.length;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(

              image: NetworkImage(
                  'https://as1.ftcdn.net/v2/jpg/06/01/48/24/1000_F_601482476_FX47F1UANQTfYA7eUp9dfBcWGJ1tbAVO.jpg'),
              fit: BoxFit.cover)),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gallery3D(
                        controller: controller,
                        height: 300.h,
                        itemConfig: GalleryItemConfig(
                            isShowTransformMask: true,
                            width: 300.w,
                            radius: 10.r,
                            height: 350.h),
                        width: MediaQuery.of(context).size.width,
                        isClip: false,
                        padding: EdgeInsets.symmetric(vertical: 10.w),
                        onItemChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: coverImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ).animate().fadeIn(duration: const Duration(seconds: 2))
                    ],
                  ),

                  Container(
                    height: 40.h,
                    width: 420.w,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: CurvedProgressBar(
                      value: progress,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  Text(profession, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    industry,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(
                    height: 5.h,
                  ),

                  // buildPageIndicator()s
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mediaPageview1() {
    double width = MediaQuery.of(context).size.width;
    Random random = Random();

    double getRandomHeight() {
      return 200 + random.nextDouble() * 50;
    }

    double itemHeight = getRandomHeight(); // Get a random height for each item

    List<String> images = [
      'https://img.freepik.com/free-photo/artistic-blurry-colorful-wallpaper-background_58702-8198.jpg?w=996&t=st=1705663252~exp=1705663852~hmac=847277a0ca5be2e642a0cb68b28f4d96074b51c1f6a699f2ba6e661d6a7a7e76',
      'https://img.freepik.com/free-photo/close-up-abstract-yellow-wallpaper_23-2147951276.jpg?w=740&t=st=1705663312~exp=1705663912~hmac=27fbcec50380c10fda6d6acbf5bf417e6048a2c5a235977483faedd4367dd3df',
      'https://c1.wallpaperflare.com/preview/50/186/499/man-male-glasses-neon.jpg',
      'https://c1.wallpaperflare.com/preview/711/806/540/portrait-neon-neon-light-alone.jpg',
      'https://c0.wallpaperflare.com/preview/131/528/1003/close-up-colorful-dark-facial-expression.jpg',
      'https://c1.wallpaperflare.com/preview/690/695/739/neon-light-portrait-woman-female.jpg',
      'https://c4.wallpaperflare.com/wallpaper/187/621/270/style-watch-actor-handsome-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/258/25/185/leonardo-dicaprio-actor-face-look-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/394/308/979/leonardo-dicaprio-leonardo-dicaprio-the-wolf-of-wall-street-jordan-belfort-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/881/551/665/the-basketball-diaries-1995-leonardo-dicaprio-jim-carroll-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/955/97/137/gun-sitting-looks-beginning-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/794/506/540/movies-inception-leonardo-dicaprio-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/456/947/809/movie-the-revenant-leonardo-dicaprio-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/15/99/677/leonardo-dicaprio-the-revenant-wallpaper-preview.jpg',
      'https://c4.wallpaperflare.com/wallpaper/406/152/1003/background-photographer-costume-actor-wallpaper-preview.jpg',
    ];
    return GridView.custom(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 12,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(3, 2),
          const QuiltedGridTile(2, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(childCount: images.length,
              (context, index) {
            return Hero(
              tag: images[index],
              child: MediaCardWidget(
                width: width,
                height: itemHeight,
                image: images[index],
                person: '353',
                title: '@alix',
                images: images,
                imageindex: index,
              ),
            );
          }),
    );
  }

  Widget digitalTheaterPageview2(List<DigitalTheatreProfileEntity> dt) {
    return dt.isEmpty
        ? const Center(child: Text("No dt to show "))
        : GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dt.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DigitaltheaterDashboardScreen(
                        digitalTheaterID: dt[index].id.toString(),
                      )));
            },
            child: MovieCard(
              image: UrlStrings.imageUrl + dt[index].poster,
              name: dt[index].title,
              year: dt[index].year.toString(),
            ),
          );
        });
  }

  Widget eventsPageview3() {
    List<Map<String, dynamic>> dummyList = [
      {
        'img':
        'https://imgstaticcontent.lbb.in/lbbnew/wp-content/uploads/sites/2/2018/06/28153320/BangaloreOpenair1.jpg',
        'day': '17',
        'month': 'Dec',
        'text1': 'Rock | English | All age groups | 10hrs',
        'text2': 'Bangalore Open Air 2024',
        'text3': 'Bits club, Bangalore',
        'date': '24th Aug',
        'points': '250',
        'row_no': '02',
        'seat_no': '12',
        'bar_id': '24082024010001',
        'is_vip': true,
      },
      {
        'img':
        'https://img.freepik.com/free-photo/close-up-abstract-yellow-wallpaper_23-2147951276.jpg?w=740&t=st=1705663312~exp=1705663912~hmac=27fbcec50380c10fda6d6acbf5bf417e6048a2c5a235977483faedd4367dd3df',
        'day': '18',
        'month': 'Dec',
        'text1': 'Pop | Hindi | All age groups | 8hrs',
        'text2': 'Music Fest 2024',
        'text3': 'City Park, Delhi',
        'date': '09th Jun',
        'points': '480',
        'row_no': '09',
        'seat_no': '08',
        'bar_id': '24082024020001',
        'is_vip': true,
      },
      {
        'img':
        'https://c1.wallpaperflare.com/preview/50/186/499/man-male-glasses-neon.jpg',
        'day': '19',
        'month': 'Dec',
        'text1': 'Electronic | English | 18+ | 12hrs',
        'text2': 'Tech Rave 2024',
        'text3': 'Tech Hub, Hyderabad',
        'date': 'th Oct',
        'points': '350',
        'row_no': '04',
        'seat_no': '06',
        'bar_id': '24082024030001',
        'is_vip': true,
      },
      // Add more dummy data as needed
    ];

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dummyList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => IndividualEventPage2(
              //               image: dummyList[index]['img']!,
              //               title: dummyList[index]['text2']!,
              //               genre: dummyList[index]['text1']!,
              //               day: '25',
              //               month: '12',
              //             )));
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => IndividualEventPage3(
              //                 image: dummyList[index]['img']!,
              //                 title: dummyList[index]['text2']!,
              //                 genre: dummyList[index]['text1']!,
              //                 day: '25',
              //                 month: '12',
              //               )));
              // },
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => IndividualEventPage4(
              //               image: dummyList[index]['img']!,
              //               title: dummyList[index]['text2']!,
              //               genre: dummyList[index]['text1']!,
              //               day: '25',
              //               month: '12',
              //               location: dummyList[index]['text3']!,
              //               date: dummyList[index]['date']!,
              //               points: dummyList[index]['points']!,
              //               row_no: dummyList[index]['row_no']!,
              //               seat_no: dummyList[index]['seat_no']!,
              //               bar_id: dummyList[index]['bar_id']!,
              //             )));
            },
            child: Hero(
              tag: dummyList[index]['img']!,
              child: EventCards(
                context: context,
                img: dummyList[index]['img']!,
                day: dummyList[index]['day']!,
                month: dummyList[index]['month']!,
                text1: dummyList[index]['text1']!,
                text2: dummyList[index]['text2']!,
                text3: dummyList[index]['text3']!,
              ),
            ),
          );
        });
  }

  Widget appbar(
      final String name,
      final String profession,
      final String industry,
      final String profilePhoto,
      List<String> coverimages,
      ) {
    return SliverAppBar(
      toolbarHeight: 100.h,
      leading: const SizedBox.shrink(),
      expandedHeight: coverHeight,backgroundColor: Colors.transparent,
      collapsedHeight: 100.h,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: Column(
          children: [
            Material(
              elevation: 8.0,
              color: const Color(0xFF1CB5E0),
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1CB5E0),
                backgroundImage: CachedNetworkImageProvider(
                    "${UrlStrings.imageUrl}$profilePhoto"),
                radius: 30.r,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
                name,
                style: Theme.of(context).textTheme.titleLarge
            ),
          ],
        ),
        background: buildCoverImage(name, profession, industry, coverimages),
      ),
    );
  }

  Widget EventCards({
    required BuildContext context,
    required String img,
    required String day,
    required String month,
    required String text1,
    required String text2,
    required String text3,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      width: MediaQuery.of(context).size.width,
      height: 120.h,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                img,
              ),
              fit: BoxFit.cover),
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white.withOpacity(0.2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      Text(
                        month,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text1,
                            style:
                            TextStyle(color: Colors.white, fontSize: 11.sp),
                          ),
                          Text(
                            text2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            text3,
                            style: TextStyle(
                                color: Colors.white70, fontSize: 11.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          )
                        ],
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget MediaCardWidget({
    required double width,
    required double height,
    required String title,
    required String person,
    required int imageindex,
    required String image,
    required List<String> images,
  }) {
    bool isZoomed = false;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          isZoomed = true;
        });
      },
      onLongPressUp: () {
        setState(() {
          isZoomed = false;
        });
      },
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => IndividualMediaPage(
        //             initialIndex: widget.imageindex, images: widget.images)));
      },
      child: Transform.scale(
        scale: isZoomed ? 1.5 : 1, // Adjust the scale for zoom level
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.fitHeight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 10.0,
                bottom: 10.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sofia",
                        fontWeight: FontWeight.w700,
                        fontSize: height * 0.07,
                        shadows: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                            spreadRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    _buildPersonContainer(
                        height: height,
                        image: image,
                        width: width,
                        title: title,
                        imageindex: imageindex,
                        images: images,
                        person: person),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonContainer({
    required double width,
    required double height,
    required String title,
    required String person,
    required int imageindex,
    required String image,
    required List<String> images,
  }) {
    double iconSize = height * 0.04;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.02),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: height * 0.01,
          bottom: height * 0.01,
          left: width * 0.02,
          right: width * 0.02,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.favorite_outlined, color: Colors.white, size: iconSize),
            Text(
              "$person Likes",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Sofia",
                fontWeight: FontWeight.w700,
                fontSize: height * 0.03,
                shadows: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
            ),
            SizedBox(width: width * 0.01),
          ],
        ),
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  final bool isSelected;
  final IconData iconData;
  final String text;

  const MyListItem({
    super.key,
    required this.isSelected,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
// Set your maximum character length

    return Center(
      child: Container(
        height: 40.h,
        width: 118.w,
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.transparent,
          border: isSelected
              ? Border.all(
            color: Colors.white.withOpacity(0.2),
          )
              : null,
          gradient: isSelected
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1CB5E0).withOpacity(0.35),
              const Color(0xFF1CB5E0).withOpacity(0.15),
            ],
          )
              : null,
          // color: isSelected
          //     ? Color(0xFF1CB5E0).withOpacity(0.2)
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // color: Colors.red,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: isSelected ? 12.sp : 10.sp,
                  ),
                )..animate()
                    .shakeX(duration: 600.ms)
                    .then(delay: 200.ms) // baseline=800ms
                    .slide(),
              ),
              // SizedBox(
              //   height: 5.h,
              // ),
              // Container(
              //   height: 4.h,
              //   width: (text.length * charLength)
              //       .clamp(0.0, maxWidth * charLength),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.r),
              //     color: isSelected
              // ? Color(0xFF1CB5E0).withOpacity(0.8)
              //         : Colors.transparent,
              //   ),
              // )
              //     .animate()
              //     .fadeIn(duration: 600.ms)
              //     .then(delay: 200.ms) // baseline=800ms
              //     .slide()
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String image;
  final String name;
  final String year;

  const MovieCard({
    super.key,
    required this.image,
    required this.name,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 250.h,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: CachedNetworkImageProvider(image)),
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.r),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  height: 70.w,
                  width: 200.w,
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.date_range_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            year,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 7.h,
            right: 7.w,
            child: Icon(Icons.play_circle_outline_rounded,
                color: Colors.white, size: 30.sp),
          ),
        ],
      ),
    );
  }
}

class CurvedProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const CurvedProgressBar(
      {super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvedProgressBarPainter(
          value: value, color: color, backgroundColor: Colors.blueGrey),
    );
  }
}

class CurvedProgressBarPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor; // New variable

  const CurvedProgressBarPainter(
      {required this.value,
        required this.color,
        required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Progress color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final backgroundPaint = Paint() // New paint object for background
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke; // Set background color

    final path = Path();
    final startPoint = Offset(0, size.height / 2);
    final endPoint = Offset(size.width, size.height / 2);

    final backgroundPath = Path();
    backgroundPath.moveTo(endPoint.dx, endPoint.dy);
    backgroundPath.quadraticBezierTo(
        size.width / 2,
        size.height + size.height / 5, // Smaller curve
        startPoint.dx,
        startPoint.dy);
    // Reverse the curve direction (same as before)
    path.moveTo(endPoint.dx, endPoint.dy);
    path.quadraticBezierTo(
        size.width / 2,
        size.height + size.height / 5, // Smaller curve
        startPoint.dx,
        startPoint.dy);

    // Draw background path
    canvas.drawPath(backgroundPath, backgroundPaint);

    final pathMetric = path.computeMetrics(); // Get metrics for the path
    final firstContour = pathMetric.first; // Assuming a single contour

    // Extract subpath based on progress (same as before)
    final progress = Path()
      ..addPath(
          firstContour.extractPath(
              firstContour.length - value * firstContour.length,
              firstContour.length),
          Offset.zero);

    canvas.drawPath(progress, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
