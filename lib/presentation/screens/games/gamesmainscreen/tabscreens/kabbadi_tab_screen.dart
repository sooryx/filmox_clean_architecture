import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/presentation/screens/games/Cricket/cricket_intro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KabbadiTabScreen extends StatelessWidget {
  KabbadiTabScreen({super.key});
  // Example of toggle button items data
  List<Map<String, dynamic>> toggleButtonItems = [
    {
      "icon": FontAwesomeIcons.personRunning,
      "label": "Kabaddi",
    },
    {
      "icon": FontAwesomeIcons.peopleGroup,
      "label": "Kabaddi League",
    },
    {
      "icon": FontAwesomeIcons.trophy,
      "label": "Kabaddi Tournament",
    },
  ];

// Example of kabaddi game data
  List<Map<String, dynamic>> gameItems = [
    {
      "team1": "Bengal Warriors",
      "team1Logo": 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9d/Bengal_Warriors_Logo.png/220px-Bengal_Warriors_Logo.png',
      "team1Score": "36",
      "team2": "Jaipur Pink Panthers",
      "team2Logo": 'https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Jaipur_Pink_panthers_logo.jpg/640px-Jaipur_Pink_panthers_logo.jpg',
      "team2Score": "32",
    },
  ];

// Updated news items for kabaddi
  List<Map<String, dynamic>> newsItems = [
    {
      "title": "Bengal Warriors clinch victory over Jaipur Pink Panthers",
      "timestamp": "Today, 7:30 PM",
      "category": "Kabaddi",
      "imageUrl": 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9d/Bengal_Warriors_Logo.png/220px-Bengal_Warriors_Logo.png',
      "isLive": true,
    },
    {
      "title": "Kabaddi League: Thrilling matches highlight opening night",
      "timestamp": "Today, 5:45 PM",
      "category": "Kabaddi League",
      "imageUrl": 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9d/Bengal_Warriors_Logo.png/220px-Bengal_Warriors_Logo.png',
      "isLive": false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 18.sp);

    TextStyle? teamNameTextStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold
    );
    Color cardColor = Colors.grey[900]!;


    return ListView(
      children: [
        const SizedBox(height: 16.0),
        ...gameItems.map((game) => _buildGameCard(context, game, teamNameTextStyle!, cardColor)).toList(),
        const SizedBox(height: 20.0),

        _currentGameCard(context: context),

        const SizedBox(height: 20.0),


        const SizedBox(height: 16.0),
        ...newsItems.map((news) => _buildNewsCard(context, news, titleTextStyle, cardColor)).toList(),
        const SizedBox(height: 16.0),
      ],
    );
  }
  Widget _buildGameCard(BuildContext context, Map<String, dynamic> game, TextStyle teamNameTextStyle, Color cardColor) {
    return InkWell(
      onTap: () =>    Navigator.push(context,
          CupertinoPageRoute(builder: (context) => CricketIntroScreen())),
      child: Card(
        elevation: 4.0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Matchday 56 of 90'),
              SizedBox(height: 10.h,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(game["team1Logo"]),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        game["team1"],
                        style: teamNameTextStyle,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                          game["team1Score"],
                          style: Theme.of(context).textTheme.titleLarge

                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      ":",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        game["team2"],
                        style: teamNameTextStyle,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                          game["team2Score"],
                          style: Theme.of(context).textTheme.titleLarge
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(game["team2Logo"]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _currentGameCard({
    required BuildContext context
  }){
    TextStyle titleTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    Color cardColor = Colors.grey[900]!;


    return
      Card(
        elevation: 4.0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 200.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://d13ir53smqqeyp.cloudfront.net/d11-static-pages/images/Bengal-Warriors-vs-Jaipur-Pink-Panthers.jpg'),
                        fit: BoxFit.cover,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Liverpool beat Lyon in Geneva to end pre-season",
                    style: titleTextStyle,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Yesterday, 9:24 PM",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Cricket",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
            Positioned(
              top: 190,
              left: 20.0,
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(4.0),
                child: const Text(
                  "LIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }
  Widget _buildNewsCard(BuildContext context, Map<String, dynamic> news, TextStyle titleTextStyle, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 10,
      child: ListTile(
        title: Text(
          news["title"],
          style: titleTextStyle,
        ),
        subtitle: Text(
          "${news["timestamp"]} | ${news["category"]}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Container(
          width: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(news["imageUrl"]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
