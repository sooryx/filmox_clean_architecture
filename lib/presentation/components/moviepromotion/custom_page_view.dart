import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmox_clean_architecture/widgets/custom_video_player.dart';
import 'package:filmox_clean_architecture/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math' as math;

class CustomPageView extends StatefulWidget {
  const CustomPageView({super.key});

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late PageController _pageController;

  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 50.h,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: 3,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double pageOffset = _currentPage - index;
                        double gauss = math.exp(
                            -(math.pow((pageOffset.abs() - 0.5), 2) / 0.099));

                        return _buildPage(context, index, gauss, pageOffset);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: Colors.white.withOpacity(0.2),
                    activeDotColor: Colors.white),
              ),
            ),
            IconButton(
                onPressed: () => _pageController.animateToPage(
                    (_pageController.page!.toInt() + 1),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ))
          ],
        )
      ],
    );
  }

  Widget _buildPage(
      BuildContext context, int index, double gauss, double pageOffset) {
    switch (index) {
      case 0:
        return _buildOverview(context, gauss, pageOffset);
      case 1:
        return _buildCastPage(context,'Cast');
      case 2:
        return _buildCastPage(context,'Crew');
      default:
        return Container();
    }
  }

  Widget _buildOverview(BuildContext context, double gauss, double pageOffset) {
    return Padding(
      padding: EdgeInsets.all(16.dg),
      child: Transform.translate(
        offset: Offset(-120 * gauss * pageOffset.sign, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, 'Overview'),
            _buildGetTicketsCard(context),
            SizedBox(height: 40.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: VideoPlayerWidget(
                  height: 300.h,
                  width: MediaQuery.of(context).size.width,
                  url: 'https://assets.mixkit.co/videos/47050/47050-720.mp4',
                  loadingWidget: const Loadingscreen()),
            ),
            SizedBox(
              height: 20.h,
            ),
            _buildRatingCard(context),
          ],
        ),
      ),
    );
  }


  Widget _buildCastPage(BuildContext context,String title ) {
    return Padding(
      padding: EdgeInsets.all(16.dg),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitle(context, title),
            SizedBox(
              height: 10.h,
            ),
            ListView.builder(
              itemCount: castList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
        
                return title == 'Cast' ?
                _buildCastCards(role: castList[index].role,image: castList[index].image,description: castList[index].description,name: castList[index].name)
                    :
                _buildCastCards(role: crewList[index].role,image: crewList[index].image,description: crewList[index].description,name: crewList[index].name);

              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGetTicketsCard(context) {
    return SizedBox(
        child: Card(
      elevation: 10,
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(12.dg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Bangalore,India",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 40.w,
                ),
                Icon(
                  Icons.alarm,
                  color: Colors.grey,
                  size: 20.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "10:35",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.grey,
                  size: 20.sp,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Get Your Tickets Now!",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 34.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Don’t miss out on the action! Purchase your tickets today for an unforgettable experience. Tap below to grab yours!",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 16.sp, color: Colors.grey),
                )),
                Container(
                  padding: EdgeInsets.all(10.dg),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildRatingCard(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "8.0",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(
                height: 50.h,
                width: 50.h,
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  value: 0.5,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                )),
          ],
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Text(
            'Rated 8.0 on IMDb, this film has garnered rave reviews for its compelling storyline, outstanding performances, and breathtaking cinematography.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _buildTitle(context, String title) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ],
      ).animate().fadeIn(duration: 600.ms, delay: 100.ms);

  Widget _buildCastCards({
    required String role,
    required String name,
    required String description,
    required String image,
  }) {
    return Container(
      margin: EdgeInsets.all(8.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Colors.grey),
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => const Loadingscreen(),
                      fit: BoxFit.cover,
                      imageUrl:
                          image),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp,
                              color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  List<Cast> castList = [
    Cast(
      'Lead Actor',
      'Tobey Maguire',
      'Tobias Vincent Maguire is an American actor and film producer. He is best known for starring as Spider-Man in Sam Raimi\'s Spider-Man trilogy, a role he later reprised in Spider-Man: No Way Home.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMzfM09Bv2-BXcsC8sEl8J6W7M8eScp4hnvw&s',
    ),
    Cast(
      'Lead Actress',
      'Kirsten Dunst',
      'Kirsten Caroline Dunst is an American actress who played Mary Jane Watson, Peter Parker\'s love interest, in Sam Raimi\'s Spider-Man trilogy.',
      'https://thegentlewoman.co.uk/img/dGY1L1lKbVZ4SmQybC9tSDQ2MmUxdz09/kirsten-01.jpg',
    ),
    Cast(
      'Supporting Actor',
      'James Franco',
      'James Edward Franco is an American actor and filmmaker who portrayed Harry Osborn, Peter Parker\'s best friend and eventual adversary, in the Spider-Man trilogy.',
      'https://i.pinimg.com/736x/f6/0f/04/f60f040db5fd363582b0398e774f1379.jpg',
    ),
    Cast(
      'Villain',
      'Willem Dafoe',
      'Willem Dafoe is an American actor who played Norman Osborn, also known as the Green Goblin, in the Spider-Man trilogy.',
      'https://media.cnn.com/api/v1/images/stellar/prod/200103075624-03-willem-dafoe.jpg?q=w_2000,c_fill',
    ),
    Cast(
      'Villain',
      'Alfred Molina',
      'Alfred Molina is a British-American actor who portrayed the villain Dr. Otto Octavius, also known as Doctor Octopus, in Spider-Man 2 and reprised his role in Spider-Man: No Way Home.',
      'https://wallpapers.com/images/hd/top-artist-alfred-molina-8251jj37oi37lqa5.jpg',
    ),
    Cast(
      'Supporting Villain',
      'Thomas Haden Church',
      'Thomas Haden Church is an American actor, director, and writer who played Flint Marko, also known as Sandman, in Spider-Man 3.',
      'https://i.pinimg.com/474x/4c/4b/da/4c4bda641eef4a095ecff26d89ff9009.jpg',
    ),
    Cast(
      'Villain',
      'Topher Grace',
      'Topher Grace is an American actor who portrayed Eddie Brock, also known as Venom, in Spider-Man 3.',
      'https://i.pinimg.com/564x/37/22/70/372270f5adb53580ec0d05a73c8296ae.jpg',
    ),
    Cast(
      'Supporting Actress',
      'Rosemary Harris',
      'Rosemary Harris is an English actress who played Aunt May in Sam Raimi\'s Spider-Man trilogy.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsOoghl6rKe7uvrK5jIOvk1t-Szb9M5kjytg&s',
    ),
  ];
  List<Cast> crewList = [
    Cast(
      'Director',
      'Sam Raimi',
      'Sam Raimi is an American filmmaker, actor, and producer best known for directing the Spider-Man trilogy, which redefined the superhero genre in the early 2000s.',
      'https://compote.slate.com/images/b51aadc4-dc12-4906-9e87-2fb30e4152a5.jpg',
    ),
    Cast(
      'Producer',
      'Laura Ziskin',
      'Laura Ziskin was an American film producer who played a significant role in bringing Spider-Man to the big screen, producing the original trilogy.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9za_h7dtqiPGmXQdzS2qZbe_P291ajPw2nQ&s',
    ),
    Cast(
      'Screenwriter',
      'David Koepp',
      'David Koepp is a renowned screenwriter responsible for writing the screenplay of the first Spider-Man film, setting the tone for the entire trilogy.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_apWAiS7wJU_jLn1f0Gfn6r9o5S6JjKErYQ&s',
    ),
    Cast(
      'Cinematographer',
      'Bill Pope',
      'Bill Pope is a cinematographer known for his dynamic and innovative visual style, which helped bring the action sequences of the Spider-Man movies to life.',
      'https://m.media-amazon.com/images/M/MV5BNDRiZjE4NDgtZjdkZi00ZjkyLTkzNGQtN2VjYjUyNDlhNDFjXkEyXkFqcGc@._V1_.jpg',
    ),
    Cast(
      'Music Composer',
      'Danny Elfman',
      'Danny Elfman is a famous composer who created the iconic score for the Spider-Man films, enhancing the film\'s emotional and action-packed scenes.',
      'https://i.pinimg.com/736x/56/7b/8c/567b8c40f04c9da2b279146105939c6a.jpg',
    ),
    Cast(
      'Editor',
      'Bob Murawski',
      'Bob Murawski is an editor who skillfully put together the scenes of the Spider-Man trilogy, ensuring a smooth flow of storytelling and pacing.',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs8rqK6ddf-Kpz3fxWeAz0-fQUcyZxB8YiRw&s',
    ),
    Cast(
      'Production Designer',
      'Neil Spisak',
      'Neil Spisak is the production designer behind the visually stunning sets of the Spider-Man films, creating the look and feel of the movie world.',
      'https://d27csu38upkiqd.cloudfront.net/eyJidWNrZXQiOiJmZGMtc2l0ZXB1YmxpYy1tZWRpYS1wcm9kIiwia2V5IjoidXBsb2Fkc1wvMjAyM1wvMDNcLzgyNjc0LmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MzIwLCJoZWlnaHQiOjQzMCwiZml0IjoiY292ZXIifX19',
    ),
    Cast(
      'Visual Effects Supervisor',
      'John Dykstra',
      'John Dykstra is a visual effects supervisor who was instrumental in developing the groundbreaking special effects that brought Spider-Man\'s powers to life.',
      'https://cdn.theasc.com/John-Dykstra-Star-Wars-1977.jpg',
    ),
  ];

}

class Cast {
  String role;
  String name;
  String description;
  String image;

  Cast(this.role, this.name, this.description, this.image);


}
