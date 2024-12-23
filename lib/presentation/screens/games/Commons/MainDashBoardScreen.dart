import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/CricketDashboard.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/CricketDetailedScreen.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

List<Match> sampleMatches = [
    // Cricket Matches
    Match(
        sport: "Cricket",
        team1: Team(
            name: "MI",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "CSK",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: true,
        score1: "180 - 5",
        score2: "175 - 8",
        venue: "Wankhede Stadium",
        description:
            "A thrilling match between Mumbai Indians and Chennai Super Kings!",
        image:
            "https://www.iplcricketmatch.com/wp-content/uploads/2024/02/Wankhede-Stadium-Pitch-Report-860x484.jpg"),
    Match(
        sport: "Cricket",
        team1: Team(
            name: "RCB",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "DC",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: false,
        result: "Royal Challengers Bangalore won",
        venue: "M. Chinnaswamy Stadium",
        description:
            "An incredible performance by Royal Challengers Bangalore!",
        image:
            "https://cf-images.eu-west-1.prod.boltdns.net/v1/static/3588749423001/8786c11b-5039-47e4-8224-50cd28c5cf20/cb36b5b6-4d21-4875-9a1d-b0e3a2e7ed11/1280x720/match/image.jpg"),
    // Kabaddi Matches
    Match(
        sport: "Kabaddi",
        team1: Team(
            name: "Patna Pirates",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "U Mumba",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: false,
        scheduledTime: "2024-11-02 19:00",
        venue: "Mumbai Arena",
        description: "A high-stakes match in the Pro Kabaddi League!",
        image:
            "https://feeds.abplive.com/onecms/images/uploaded-images/2023/10/27/194b13d77d33327f6b1a3ee86e64e7dc1698390002140555_original.png?impolicy=abp_cdn&imwidth=1200&height=675"),
    Match(
        sport: "Kabaddi",
        team1: Team(
            name: "Bengal Warriors",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "Gujarat Fortunegiants",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: true,
        score1: "35",
        score2: "42",
        venue: "Kolkata Stadium",
        description: "An intense Kabaddi face-off between top teams!",
        image:
            "https://static.toiimg.com/thumb/msid-105791154,width-1280,height-720,resizemode-4/105791154.jpg"),
    // Throwball Matches
    Match(
        sport: "Throwball",
        team1: Team(
            name: "Team Alpha",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "Team Beta",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: true,
        score1: "3",
        score2: "2",
        venue: "National Sports Complex",
        description: "A closely fought throwball match!",
        image:
            "https://www.iplt20.com/assets/images/stadiumimage/M.Chinnaswamy-Stadium.jpg"),
    Match(
        sport: "Throwball",
        team1: Team(
            name: "Phoenix",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "Titans",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: false,
        result: "Titans won",
        venue: "Arena Sports Ground",
        description: "An exhilarating game between Phoenix and Titans.",
        image:
            "https://www.probatsman.com/wp-content/uploads/2024/09/No-Expansion-of-IPL-2025.jpg"),
    // KhoKho Matches
    Match(
        sport: "KhoKho",
        team1: Team(
            name: "Warriors",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "Defenders",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: false,
        result: "Warriors won",
        venue: "KhoKho Arena",
        description: "An intense KhoKho match!",
        image:
            "https://fallinsports.com/wp-content/uploads/2021/01/Feature-Image-FallinSports-Post-What-is-the-Kho-kho-and-more-about-Kho-kho.png"),
    Match(
        sport: "KhoKho",
        team1: Team(
            name: "Invincibles",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png"),
        team2: Team(
            name: "Strikers",
            logoUrl:
                "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png"),
        isLive: true,
        score1: "10",
        score2: "8",
        venue: "City Sports Ground",
        description: "An exciting KhoKho game with lots of action!",
        image: "https://bharatiyakhel.in/wp-content/uploads/2024/01/kho.png"),
  ];

class Team {
  final String name;
  final String? logoUrl;

  Team({
    required this.name,
    this.logoUrl,
  });
}

class Match {
  final String sport;
  final Team team1;
  final Team team2;
  final bool isLive;
  final String? score1;
  final String? score2;
  final String? result;
  final String? scheduledTime;
  final String? venue;
  final String? description;
  final String? image;

  Match({
    required this.sport,
    required this.team1,
    required this.team2,
    required this.isLive,
    this.score1,
    this.score2,
    this.result,
    this.scheduledTime,
    this.venue,
    this.description,
    this.image,
  });
}

class Maindashboardscreen extends StatefulWidget {
  const Maindashboardscreen({super.key});

  @override
  State<Maindashboardscreen> createState() => _MaindashboardscreenState();
}

class _MaindashboardscreenState extends State<Maindashboardscreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedSport = "All"; // default selected sport

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  

  List<Match> getFilteredMatches() {
    if (selectedSport == "All") return sampleMatches;
    return sampleMatches
        .where((match) => match.sport == selectedSport)
        .toList();
  }

  List<Match> getFilteredMatches2() {
    List<Match> filteredMatches;

    if (selectedSport == "All") {
      filteredMatches = List.from(sampleMatches);
    } else {
      filteredMatches =
          sampleMatches.where((match) => match.sport == selectedSport).toList();
    }

    // Sort alphabetically by team1 name
    filteredMatches.sort((a, b) => a.team1.name.compareTo(b.team1.name));
    return filteredMatches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 460.0.h,
                      autoPlay: true,
                      autoPlayCurve: Curves.slowMiddle,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                    ),
                    items: getFilteredMatches().map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(i.image!),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.65),
                                    Colors.black.withOpacity(0.7),
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.0),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            if (i.team1.logoUrl != null)
                                              Image.network(
                                                i.team1.logoUrl!,
                                                height: 50,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            SizedBox(height: 4),
                                            Text(
                                              i.team1.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontSize: 20),
                                            ),
                                            if (i.score1 != null)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  "${i.score1}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(fontSize: 20),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            if (i.team2.logoUrl != null)
                                              Image.network(
                                                i.team2.logoUrl!,
                                                height: 50,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            SizedBox(height: 4),
                                            Text(
                                              i.team2.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontSize: 20),
                                            ),
                                            if (i.score2 != null)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  "${i.score2}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(fontSize: 20),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (i.result != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Result: ${i.result}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontSize: 14),
                                        ),
                                      ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      i.description ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Center(
                                      child: CommonWidgets.customButton(
                                          context: context,
                                          icon: Icons.play_arrow,
                                          text: i.isLive ? "Watch" : "Preview",
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child:
                                                        const Cricketdetailedscreen(),
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    duration:
                                                        Durations.extralong1));
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Live Matches",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: 18,
                                color: Theme.of(context).canvasColor),
                        textAlign: TextAlign.start,
                      ),
                      const Spacer(),
                      Text(
                        "View All",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14, color: Theme.of(context).canvasColor),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 130.h,
                  width: double.infinity,
                  child: Builder(
                    builder: (context) {
                      List<Match> liveMatches = getFilteredMatches();
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: liveMatches.length,
                        itemBuilder: (context, index) {
                          final match = liveMatches[index];
                          if (match.isLive) {
                            return Card(
                              surfaceTintColor: Colors.transparent,
                              color: Colors.transparent,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                width: 320.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    children: [
                                      // Blurred background image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 0.9, sigmaY: 0.9),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    NetworkImage(match.image!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Black gradient overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.6),
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white70,
                                                size: 16,
                                              ),
                                              SizedBox(width: 2),
                                              Text("1.2k",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Main content inside the card
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      match.team1.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      match.score1 ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      match.team2.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      match.score2 ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16)
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${match.venue ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Top Picks",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: 18,
                                color: Theme.of(context).canvasColor),
                        textAlign: TextAlign.start,
                      ),
                      buildMatchList()
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 44.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              height: 54.h,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    selectedSport = [
                      "All",
                      "Cricket",
                      "Kabaddi",
                      "Throwball",
                      "KhoKho"
                    ][index];
                  });
                },
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
                      ? null
                      : Colors.transparent;
                }),
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                automaticIndicatorColorAdjustment: true,
                dividerColor: Colors.transparent,
                isScrollable: true,
                enableFeedback: false,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).primaryColorDark.withOpacity(0.4),
                    ],
                  ),
                ),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 22.sp),
                unselectedLabelStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18.sp),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Cricket'),
                  Tab(text: 'Kabaddi'),
                  Tab(text: 'Throwball'),
                  Tab(text: 'KhoKho'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMatchList() {
    List<Match> filteredMatches = getFilteredMatches2();
    return Column(
      children: List.generate(
        filteredMatches.length,
        (index) {
          final match = filteredMatches[index];
          return CricketDashboardWidget(
            backgroundImageUrl: match.image ?? '',
            logoImageUrl: match.team1.logoUrl ?? "",
            title: "${match.team1.name} vs ${match.team2.name}",
            description: match.description ?? "",
            isLive: match.isLive,
            onWatchPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const Cricketdetailedscreen(),
                      duration: Durations.extralong1,
                      type: PageTransitionType.bottomToTop));
            },
          );
        },
      ),
    );
  }
}
