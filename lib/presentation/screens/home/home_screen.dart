// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/presentation/screens/entrypoint/custom_drawer.dart';
import 'package:filmox_clean_architecture/widgets/animated_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final avatarWaitingDuration = 400.ms;
  final namePlayDuration = 800.ms;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {});
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.menu_rounded, size: 35.sp),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  color: Colors.white,
                ),
               const  Expanded(
                  child: AnimatedAppBarWidget(
                    avatarWaitingDuration: Duration(seconds: 1),
                    avatarPlayDuration: Duration(seconds: 1),
                    nameDelayDuration: Duration(milliseconds: 300),
                    namePlayDuration: Duration(seconds: 1),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Midpart()
                .animate()
                .fadeIn(delay: 3500.ms, duration: 2000.ms)
                .then()
                .animate()
                .shimmer(delay: 5500.ms, duration: 1000.ms)
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
        padding: EdgeInsets.all(10.dg),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,Soorajith",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey),
                        ),
                        Text(
                          "Let's explore!",
                          style: TextStyle(
                              fontSize: 24.sp,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ));
  }
}

class Midpart extends StatelessWidget {
  Midpart({super.key});

  List<storydummy> storyData = [
    storydummy(
      name: 'Joker',
      userImage:
          'https://i.guim.co.uk/img/media/fbb1974c1ebbb6bf4c4beae0bb3d9cb93901953c/80_0_2400_1440/master/2400.jpg?width=1020&dpr=2&s=none&crop=none',
      image:
          'https://c4.wallpaperflare.com/wallpaper/221/116/854/joaquin-phoenix-joker-batman-fire-car-hd-wallpaper-preview.jpg',
    ),
    storydummy(
      name: 'Spiderman',
      userImage:
          'https://c4.wallpaperflare.com/wallpaper/418/741/320/spiderman-hd-4k-5k-wallpaper-thumb.jpg',
      image:
          'https://c4.wallpaperflare.com/wallpaper/611/838/413/spiderman-hd-4k-superheroes-wallpaper-preview.jpg',
    ),
    storydummy(
      name: 'Batman',
      userImage:
          'https://c4.wallpaperflare.com/wallpaper/1008/519/714/batman-dc-comics-video-games-the-dark-knight-wallpaper-thumb.jpg',
      image:
          'https://c4.wallpaperflare.com/wallpaper/314/216/1004/batman-digital-art-comics-artwork-wallpaper-preview.jpg',
    ),
  ];

  List<feedDummy> feedData = [
    feedDummy(
        name: 'Arkham Nights',
        image:
            'https://c4.wallpaperflare.com/wallpaper/81/165/261/batman-the-dark-knight-movies-wallpaper-preview.jpg',
        userImage:
            'https://c4.wallpaperflare.com/wallpaper/1008/519/714/batman-dc-comics-video-games-the-dark-knight-wallpaper-thumb.jpg',
        desc:
            'Batman: Arkham Knight is a 2015 action-adventure game developed by Rocksteady Studios and published by Warner Bros. Interactive Entertainment.',
        time: '1 h ago'),
    feedDummy(
        name: 'Scarecrow',
        image:
            'https://c4.wallpaperflare.com/wallpaper/136/525/93/batman-arkham-knight-batman-scarecrow-character-rocksteady-studios-wallpaper-preview.jpg',
        userImage:
            'https://c4.wallpaperflare.com/wallpaper/40/993/282/batman-rocksteady-studios-batman-arkham-knight-video-games-wallpaper-thumb.jpg',
        desc:
            'The Scarecrow is a supervillain appearing in American comic books published by DC Comics. Created by Bill Finger and Bob Kane, the character first appeared in World\'s Finest Comics',
        time: '2 h ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Featured Highlights",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              itemCount: storyData.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return makeStory(
                    storyImage: storyData[index].image,
                    userImage: storyData[index].userImage,
                    userName: storyData[index].name,
                    context: context);
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Popluar Media",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                letterSpacing: 1.2),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: feedData.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => makeFeed(
                context: context,
                feedImage: feedData[index].image,
                feedText: feedData[index].desc,
                feedTime: feedData[index].time,
                userImage: feedData[index].image,
                userName: feedData[index].name),
          )
        ],
      ),
    );
  }

  Widget makeStory(
      {required String storyImage,
      required String userImage,
      required String userName,
      required BuildContext context}) {
    return AspectRatio(
      aspectRatio: 1.6 / 2,
      child: Container(
        margin: EdgeInsets.all(10.dg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: CachedNetworkImageProvider(storyImage), fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.1),
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(userImage),
                        fit: BoxFit.cover)),
              ),
              Text(userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 16.sp))
            ],
          ),
        ),
      ),
    );
  }

  Widget makeFeed(
      {required String userName,
      required String userImage,
      required String feedTime,
      required String feedText,
      required String feedImage,
      required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10.dg),
      margin: EdgeInsets.all(10.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(userImage), fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(feedTime,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 30.sp,
                  color: Colors.grey[600],
                ),
                onPressed: () {},
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            feedText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 20.h,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
                height: 250.h, fit: BoxFit.cover, imageUrl: feedImage),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLike(),
                  Transform.translate(
                      offset: const Offset(-5, 0), child: makeLove()),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "2.5K",
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  )
                ],
              ),
              Text(
                "400 Comments",
                style: TextStyle(fontSize: 13.sp, color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget makeLike() {
    return Container(
      width: 25.w,
      height: 25.h,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: const Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLove() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: const Center(
        child: Icon(Icons.favorite, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLikeButton({isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Like",
              style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeCommentButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chat, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Comment",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeShareButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Share",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class storydummy {
  String name;
  String image;
  String userImage;

  storydummy(
      {required this.name, required this.image, required this.userImage});
}

class feedDummy {
  String name;
  String image;
  String userImage;
  String desc;
  String time;

  feedDummy(
      {required this.name,
      required this.image,
      required this.userImage,
      required this.desc,
      required this.time});
}
