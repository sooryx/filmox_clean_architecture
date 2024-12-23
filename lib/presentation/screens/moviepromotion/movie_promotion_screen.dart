// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'individula_movie_promotion_main_screen.dart';

class MoviePromotionScreen extends StatelessWidget {
  MoviePromotionScreen({super.key});

  List<String> posters = [
    'https://r4.wallpaperflare.com/wallpaper/822/323/828/spiderman-into-the-spider-verse-2018-movies-movies-spiderman-wallpaper-48a68d5870204c58a00cb15ed892242a.jpg',
    'https://r4.wallpaperflare.com/wallpaper/658/995/627/christopher-nolan-s-interstellar-wallpaper-2f1c729fdd69e588c70db21494e39010.jpg',
    'https://r4.wallpaperflare.com/wallpaper/29/41/144/dunkirk-spitfire-tom-hardy-christopher-nolan-hd-wallpaper-68262de850c0ac38d04cc13ed882e46a.jpg',
    'https://r4.wallpaperflare.com/wallpaper/368/513/202/the-dark-knight-rises-movies-film-stills-batman-christian-bale-hd-wallpaper-f9d0b84da15a1d7b361798dfa031868d.jpg'
  ];

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
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: posters.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) =>
            _buildCard(image: posters[index], context: context,index: index),
      ),
    );
  }

  Widget _buildCard({required String image, required BuildContext context,required int index}) {
    return InkWell(
      onTap: () {
           Navigator.push(context,
                       CupertinoPageRoute(builder: (context) => IndividulaMoviePromotionMainScreen(bgImage: image,index: index,)));
      },
      child: SizedBox(
        height: 250.h,
        width: double.infinity,
        child: Stack(
          children: [
            Hero(
              tag: 'bg-image-$index',
              child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(image))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Spider Man",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "Christopher Nolan",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontSize: 16.sp, color: Colors.white),
                          ),

                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text("50",style: Theme.of(context).textTheme.bodySmall,),

                              SizedBox(
                                  height:40.h,
                                  width:40.h,

                                  child: CircularProgressIndicator(color: Colors.orange,value: 0.5,backgroundColor: Colors.grey.withOpacity(0.3),)),
                            ],
                          ),
                          SizedBox(height: 20.h,),
                          Text(
                            "Rating",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(fontSize: 16.sp, color: Colors.white),
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
              child: Container(
                height: 50.h, // Adjust the height as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
