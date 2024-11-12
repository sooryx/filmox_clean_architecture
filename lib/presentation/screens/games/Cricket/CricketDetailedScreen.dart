
import 'package:filmox_clean_architecture/presentation/screens/games/Commons/MainDashBoardScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Commons/WatchPartyScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/CricketDashboard.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/Helper/CricketTeamsScreen.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/Helper/MatchInfo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import 'Helper/CricketScorecardScreen.dart';

class Cricketdetailedscreen extends StatefulWidget {
  const Cricketdetailedscreen({super.key});

  @override
  State<Cricketdetailedscreen> createState() => _CricketdetailedscreenState();
}

class _CricketdetailedscreenState extends State<Cricketdetailedscreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    // Update the length to match the number of tabs
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250.0,
              toolbarHeight: 0,
              collapsedHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://images.ottplay.com/images/ccl-703.jpg?impolicy=ottplay-20210210&width=350&height=200",
                      ),
                    ),
                  ),
                ),
              ),
              floating: false,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BAN A vs HKG",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Men's T20 Emerging Teams Asia Cup 2024",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,  // Make sure TabBar uses the correct controller
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      return states.contains(WidgetState.focused)
                          ? null
                          : Colors.transparent;
                    },
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  enableFeedback: false,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.35),
                        Theme.of(context).primaryColorDark.withOpacity(0.15),
                      ],
                    ),
                  ),
                  labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20.0),
                  unselectedLabelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.0),
                  tabs: const [
                    Tab(text: 'Match Info'),
                    Tab(text: 'Scorecard'),
                    Tab(text: 'Teams'),
                    Tab(text: 'Watch Party'),
                    Tab(text: 'Videos'),
                    Tab(text: 'Match Info'),  // Ensure the number of tabs matches the length of the TabController
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,  // Ensure TabBarView uses the same controller
          dragStartBehavior: DragStartBehavior.start,
          children: [
            LeagueDetailsScreen(
              tournamentName: 'Celebrity Champions League, 2024-25',
              matchDetails: 'Match 1, T20, Celebrity Champions League, 2024-25',
              startTime: '7:00 PM, 20 Nov, 2024',
              venue: 'M. Chinnaswamy Stadium, Bengaluru, India',
              team1Name: 'Karnataka',
              team1FlagUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/35/Karnataka_Flag.png',
              team2Name: 'Tamil Nadu',
              team2FlagUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/47/TamilNadu_Flag.png',
              tossResult: 'Won the toss and decided to bat',
            ),
            const CricketScorecardScreen(),
            CricketTeamScreen(),
            WatchPartyScreen(),
            _buildTabContent('Highlights Data'),
            _buildTabContent('Match Info Data'),
          ],
        ),
      ),
    );
  }


  String selectedSport = "All";

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

  Widget buildMatchList() {
    List<Match> filteredMatches = getFilteredMatches2();
    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }

  // A simple helper method to mock each tab's content
  Widget _buildTabContent(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
