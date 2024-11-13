import 'package:filmox_clean_architecture/presentation/screens/moviepromotion/indiviudal_mp_screen/individual_movie_promotion_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoviePromotionScreen extends StatelessWidget {
  MoviePromotionScreen({super.key});

  List<Map<String, String>> movieItems = [
    {
      "title": "Spider-Man: \nNo Way Home",
      "poster":
          "https://r4.wallpaperflare.com/wallpaper/822/323/828/spiderman-into-the-spider-verse-2018-movies-movies-spiderman-wallpaper-48a68d5870204c58a00cb15ed892242a.jpg",
      "direction": "Jon Watts",
      "rating": "85",
      "hot": "true"
    },
    {
      "title": "Interstellar",
      "poster":
          "https://c4.wallpaperflare.com/wallpaper/631/218/373/4k-interstellar-matthew-mcconaughey-astronaut-wallpaper-preview.jpg",
      "direction": "Christopher Nolan",
      "rating": "95",
      "hot": "false"
    },
    {
      "title": "Dunkirk",
      "poster":
          'https://r4.wallpaperflare.com/wallpaper/29/41/144/dunkirk-spitfire-tom-hardy-christopher-nolan-hd-wallpaper-68262de850c0ac38d04cc13ed882e46a.jpg',
      "direction": "Christopher Nolan",
      "rating": "80",
      "hot": "false"
    },
    {
      "title": "The Dark Knight Rises",
      "poster":
          'https://r4.wallpaperflare.com/wallpaper/368/513/202/the-dark-knight-rises-movies-film-stills-batman-christian-bale-hd-wallpaper-f9d0b84da15a1d7b361798dfa031868d.jpg',
      "direction": "Christopher Nolan",
      "rating": "95",
      "hot": "false"
    },
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
        itemCount: movieItems.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => _buildCard(
            image: movieItems[index]['poster'] ?? '',
            title: movieItems[index]['title'] ?? '',
            director: movieItems[index]['direction'] ?? '',
            rating: movieItems[index]['rating'] ?? '',
            context: context,
            index: index),
      ),
    );
  }

  Widget _buildCard(
      {required String image,
      required String title,
      required String director,
      required String rating,
      required BuildContext context,
      required int index}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => IndividualMoviePromotionScreen(
                      bgImage: image,
                      index: index,
                    )));
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            director,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                    fontSize: 16.sp, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                rating,
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
                                    fontSize: 16.sp, color: Colors.white),
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
