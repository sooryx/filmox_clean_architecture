import 'package:filmox_clean_architecture/presentation/screens/games/gamesmainscreen/tabscreens/circket_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'tabscreens/kabbadi_tab_screen.dart';

class GamesMainScreen extends StatelessWidget {
  const GamesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.surface),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("Sports Feed"),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.search),
              onPressed: () {},
            )
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.baseball), text: 'Cricket'),
              Tab(icon: Icon(FontAwesomeIcons.basketball), text: 'Kabbadi'),
              Tab(icon: Icon(FontAwesomeIcons.hockeyPuck), text: 'Hockey'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CircketTabScreen(),
            KabbadiTabScreen(),
            CircketTabScreen(),
          ],
        ),
      ),
    );
  }


}
