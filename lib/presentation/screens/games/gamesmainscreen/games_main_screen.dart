import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GamesMainScreen extends StatelessWidget {
  const GamesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    Color primaryColor = Theme.of(context).primaryColor;
    Color cardColor = Colors.grey[900]!;

    TextStyle titleTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    TextStyle? teamNameTextStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: 18.sp,
      color: Colors.white,
    );

    // Example of toggle button items data
    List<Map<String, dynamic>> toggleButtonItems = [
      {
        "icon": FontAwesomeIcons.baseball,
        "label": "Cricket",
      },
      {
        "icon": FontAwesomeIcons.basketball,
        "label": "Kabbadi",
      },
      {
        "icon": FontAwesomeIcons.basketball,
        "label": "Hockey",
      },
    ];

    // Example of game data
    List<Map<String, dynamic>> gameItems = [
      {
        "team1": "Mumbai Indians",
        "team1Logo": 'https://upload.wikimedia.org/wikipedia/en/thumb/c/cd/Mumbai_Indians_Logo.svg/640px-Mumbai_Indians_Logo.svg.png',
        "team1Score": "0",
        "team2": "Gremio",
        "team2Logo": 'https://ih1.redbubble.net/image.4991347803.8059/flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
        "team2Score": "2",
      },
    ];

    List<Map<String, dynamic>> newsItems = [
      {
        "title": "Liverpool beat Lyon in Geneva to end pre-season",
        "timestamp": "Yesterday, 9:24 PM",
        "category": "Cricket",
        "imageUrl": 'https://res.cloudinary.com/jerrick/image/upload/d_642250b563292b35f27461a7.png,f_jpg,fl_progressive,q_auto,w_1024/6453dc6585fbb0001d9a2826.jpg',
        "isLive": true,
      },
      {
        "title": "Cosgrove hat-tricks sparks Aberdeen",
        "timestamp": "Yesterday, 7:02 PM",
        "category": "Aberdeen",
        "imageUrl": AppConstants.filmoxLogo,
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildToggleButtons(context, toggleButtonItems, primaryColor),
          const SizedBox(height: 16.0),
          ...gameItems.map((game) => _buildGameCard(context, game, teamNameTextStyle!, cardColor)).toList(),
          const SizedBox(height: 20.0),

          _currentGameCard(context: context),

          const SizedBox(height: 20.0),


          const SizedBox(height: 16.0),
          ...newsItems.map((news) => _buildNewsCard(context, news, titleTextStyle, cardColor)).toList(),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(BuildContext context, List<Map<String, dynamic>> items, Color primaryColor) {
    return Center(
      child: ToggleButtons(
        fillColor: primaryColor,
        hoverColor: primaryColor,
        renderBorder: true,
        borderColor: Colors.grey.shade300,
        color: Colors.grey.shade800,
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        isSelected: List.generate(items.length, (index) => index == 0),
        onPressed: (index) {},
        children: items.map((item) => Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(item["icon"]),
              const SizedBox(height: 16.0),
              Text(
                item["label"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, Map<String, dynamic> game, TextStyle teamNameTextStyle, Color cardColor) {
    return Card(
      elevation: 4.0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundImage: NetworkImage(game["team2Logo"]),
            ),
          ],
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

  Theme.of(context).textTheme.headlineLarge?.copyWith(
    fontSize: 18.sp,
    color: Colors.white,
  );
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
                           'https://res.cloudinary.com/jerrick/image/upload/d_642250b563292b35f27461a7.png,f_jpg,fl_progressive,q_auto,w_1024/6453dc6585fbb0001d9a2826.jpg'),
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
