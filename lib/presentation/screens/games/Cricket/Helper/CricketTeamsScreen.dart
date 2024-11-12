import 'package:flutter/material.dart';

class CricketTeamScreen extends StatefulWidget {
  @override
  _CricketTeamScreenState createState() => _CricketTeamScreenState();
}

class _CricketTeamScreenState extends State<CricketTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSectionTitle('Playing 11 for the Match'),
            _buildTeamPlayers(),
            _buildSectionTitle('Bench'),
            _buildBenchPlayers(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png',
                height: 40,
              ),
              SizedBox(height: 4),
              Text(
                'Karnataka',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          // Spacer(),
          Column(
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png',
                height: 40,
              ),
              SizedBox(height: 4),
              Text(
                'Tamilnadu',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white60,
        ),
      ),
    );
  }

  Widget _buildTeamPlayers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildLeftTeamColumn(_karATeamPlayers())),
          Container(
            width: 1,
            color: Colors.grey[800],
          ),
          Expanded(child: _buildRightTeamColumn(_karBTeamPlayers())),
        ],
      ),
    );
  }

  Widget _buildLeftTeamColumn(List<Map<String, String>> players) {
    return Column(
      children: players.map((player) {
        return _buildLeftTeamPlayerRow(
          player['image']!,
          player['role']!,
          player['name']!,
          player['handedness']!,
        );
      }).toList(),
    );
  }

  Widget _buildRightTeamColumn(List<Map<String, String>> players) {
    return Column(
      children: players.map((player) {
        return _buildRightTeamPlayerRow(
          player['image']!,
          player['role']!,
          player['name']!,
          player['handedness']!,
        );
      }).toList(),
    );
  }

  Widget _buildLeftTeamPlayerRow(
      String imageUrl, String role, String name, String handedness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://i.pinimg.com/736x/26/4f/80/264f80349fee9ab497afefa361ac4755.jpg"),
            radius: 22,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                handedness,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightTeamPlayerRow(
      String imageUrl, String role, String name, String handedness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                role,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                handedness,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.nicepng.com/png/detail/266-2667128_virat-kohli-png-transparent-image-virat-kohli-png.png"),
            radius: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildBenchPlayers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildLeftTeamColumn(_karABenchPlayers())),
          Container(
            width: 1,
            color: Colors.grey[800],
          ),
          Expanded(child: _buildRightTeamColumn(_karBBenchPlayers())),
        ],
      ),
    );
  }

  List<Map<String, String>> _karATeamPlayers() {
    return [
      {
        'name': 'Manish Pandey (C)',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/manish_pandey.png'
      },
      {
        'name': 'Devdutt Padikkal',
        'role': 'BAT',
        'handedness': 'Left Handed',
        'image': 'assets/devdutt_padikkal.png'
      },
      {
        'name': 'Mayank Agarwal',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/mayank_agarwal.png'
      },
      {
        'name': 'Karun Nair',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/karun_nair.png'
      },
      {
        'name': 'KL Rahul (WK)',
        'role': 'WK-BAT',
        'handedness': 'Right Handed',
        'image': 'assets/kl_rahul.png'
      },
      {
        'name': 'Vinay Kumar',
        'role': 'BOWL',
        'handedness': 'Right-arm medium',
        'image': 'assets/vinay_kumar.png'
      },
      {
        'name': 'Shreyas Gopal',
        'role': 'ALL',
        'handedness': 'Right-arm leg break',
        'image': 'assets/shreyas_gopal.png'
      },
      {
        'name': 'Prasidh Krishna',
        'role': 'BOWL',
        'handedness': 'Right-arm fast',
        'image': 'assets/prasidh_krishna.png'
      },
      {
        'name': 'Jagadeesha Suchith',
        'role': 'ALL',
        'handedness': 'Slow left-arm orthodox',
        'image': 'assets/jagadeesha_suchith.png'
      },
      {
        'name': 'S Arvind',
        'role': 'BOWL',
        'handedness': 'Left-arm medium',
        'image': 'assets/s_arvind.png'
      },
      {
        'name': 'Stuart Binny',
        'role': 'ALL',
        'handedness': 'Right Handed',
        'image': 'assets/stuart_binny.png'
      },
    ];
  }

  List<Map<String, String>> _karBTeamPlayers() {
    return [
      {
        'name': 'Abhimanyu Mithun (C)',
        'role': 'BOWL',
        'handedness': 'Right-arm medium',
        'image': 'assets/abhimanyu_mithun.png'
      },
      {
        'name': 'Ravikumar Samarth',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/ravikumar_samarth.png'
      },
      {
        'name': 'Ronit More',
        'role': 'BOWL',
        'handedness': 'Right-arm medium',
        'image': 'assets/ronit_more.png'
      },
      {
        'name': 'Sharath Srinivas (WK)',
        'role': 'WK-BAT',
        'handedness': 'Right Handed',
        'image': 'assets/sharath_srinivas.png'
      },
      {
        'name': 'Krishnappa Gowtham',
        'role': 'ALL',
        'handedness': 'Right-arm offbreak',
        'image': 'assets/krishnappa_gowtham.png'
      },
      {
        'name': 'Nikin Jose',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/nikin_jose.png'
      },
      {
        'name': 'Shreyas Iyer',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/shreyas_iyer.png'
      },
      {
        'name': 'R. Vinay Kumar',
        'role': 'BOWL',
        'handedness': 'Right-arm medium',
        'image': 'assets/vinay_kumar.png'
      },
      {
        'name': 'Aniruddha Joshi',
        'role': 'ALL',
        'handedness': 'Right-arm offbreak',
        'image': 'assets/aniruddha_joshi.png'
      },
      {
        'name': 'K. Gowtham',
        'role': 'ALL',
        'handedness': 'Right-arm offbreak',
        'image': 'assets/k_gowtham.png'
      },
      {
        'name': 'Mohammed Taha',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/mohammed_taha.png'
      },
    ];
  }

  List<Map<String, String>> _karABenchPlayers() {
    return [
      {
        'name': 'Shubhang Hegde',
        'role': 'ALL',
        'handedness': 'Slow left-arm orthodox',
        'image': 'assets/shubhang_hegde.png'
      },
      {
        'name': 'Bharath Chipli',
        'role': 'BAT',
        'handedness': 'Right Handed',
        'image': 'assets/bharath_chipli.png'
      },
      {
        'name': 'K. Gowtham',
        'role': 'ALL',
        'handedness': 'Right-arm offbreak',
        'image': 'assets/k_gowtham.png'
      },
    ];
  }

  List<Map<String, String>> _karBBenchPlayers() {
    return [
      {
        'name': 'S. Aravind',
        'role': 'BOWL',
        'handedness': 'Left-arm medium',
        'image': 'assets/s_aravind.png'
      },
      {
        'name': 'J Suchith',
        'role': 'BOWL',
        'handedness': 'Slow left-arm orthodox',
        'image': 'assets/j_suchith.png'
      },
      {
        'name': 'S Manjunath',
        'role': 'ALL',
        'handedness': 'Right Handed',
        'image': 'assets/s_manjunath.png'
      },
    ];
  }
}
