import 'package:flutter/material.dart';

class CricketScorecardScreen extends StatefulWidget {
  const CricketScorecardScreen({super.key});

  @override
  State<CricketScorecardScreen> createState() => _CricketScorecardScreenState();
}

class _CricketScorecardScreenState extends State<CricketScorecardScreen> {
  List<bool> _isExpanded = [true, false]; // Track expansion state for each team

  // Sample data for batting and bowling status
  final List<Map<String, dynamic>> battingData = [
    {
      'name': 'Manish Pandey\nc D Kosala b H Manenti',
      'runs': '30',
      'balls': '24',
      'fours': '3',
      'sixes': '1',
      'strikeRate': '125.0',
      'isNotOut': false // Not highlighted
    },
    {
      'name': 'Mayank Agarwal\nc M Campopiano b D Kosala',
      'runs': '50',
      'balls': '36',
      'fours': '4',
      'sixes': '2',
      'strikeRate': '138.9',
      'isNotOut': false
    },
    {
      'name': 'Devdutt Padikkal\nc A Mosca b D Kosala',
      'runs': '25',
      'balls': '20',
      'fours': '1',
      'sixes': '1',
      'strikeRate': '125.0',
      'isNotOut': false
    },
    {
      'name': 'Karun Nair\nc G Berg b D Kosala',
      'runs': '10',
      'balls': '15',
      'fours': '0',
      'sixes': '0',
      'strikeRate': '66.7',
      'isNotOut': false
    },
    {
      'name': 'Shreyas Gopal\nbatting',
      'runs': '5',
      'balls': '8',
      'fours': '0',
      'sixes': '0',
      'strikeRate': '62.5',
      'isNotOut': true
    },
  ];

  final List<Map<String, dynamic>> bowlingData = [
    {
      'name': 'Vinay Kumar',
      'overs': '4',
      'maidens': '1',
      'runs': '25',
      'wickets': '2',
      'economy': '6.25',
      'isCurrentBowler':
          true // Add * symbol if this bowler is currently bowling
    },
    {
      'name': 'Prasidh Krishna',
      'overs': '4',
      'maidens': '0',
      'runs': '19',
      'wickets': '1',
      'economy': '4.75',
      'isCurrentBowler': false
    },
    {
      'name': 'Abhimanyu Mithun',
      'overs': '3',
      'maidens': '0',
      'runs': '13',
      'wickets': '2',
      'economy': '4.33',
      'isCurrentBowler': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTeamScorecard(
              'KAR-A', '120-4 (16.5)', 'Karnataka B chose to field.', 0),
          _buildTeamScorecard('KAR-B', 'Yet to Bat', '', 1),
        ],
      ),
    );
  }

  Widget _buildTeamScorecard(
      String teamName, String score, String status, int index) {
    return Theme(
      data: ThemeData.dark(), // Set dark theme specifically for this component
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.all(0),
        animationDuration: Duration(milliseconds: 500),
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _isExpanded[index] = !_isExpanded[index];
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      teamName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      score,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: status.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : null,
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBattingTable(),
                  SizedBox(height: 16.0),
                  _buildExtrasSection(),
                  SizedBox(height: 16.0),
                  _buildBowlingTable(),
                  SizedBox(height: 16.0),
                  _buildFallOfWicketsTable(),
                ],
              ),
            ),
            isExpanded: _isExpanded[index],
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBattingTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BATTING",
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 8.0),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey[700]!),
          ),
          columnWidths: const {
            0: FlexColumnWidth(5), // Player name
            1: FlexColumnWidth(1), // Runs
            2: FlexColumnWidth(1), // Balls
            3: FlexColumnWidth(0.8), // Fours
            4: FlexColumnWidth(0.8), // Sixes
            5: FlexColumnWidth(1), // Strike Rate
          },
          children: [
            _buildTableRow(['Batsman', 'R', 'B', '4s', '6s', 'SR'],
                isHeader: true),
            for (var player in battingData)
              _buildTableRow(
                [
                  player['isNotOut'] ? "${player['name']} *" : player['name'],
                  player['runs'],
                  player['balls'],
                  player['fours'],
                  player['sixes'],
                  player['strikeRate']
                ],
                isHighlighted: player['isNotOut'],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildExtrasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EXTRAS",
          style: TextStyle(color: Colors.grey[400]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "12 (b 1, lb 1, nb 0, w 10, p 0)",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBowlingTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BOWLING",
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 8.0),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey[700]!),
          ),
          columnWidths: const {
            0: FlexColumnWidth(5), // Bowler name
            1: FlexColumnWidth(1), // Overs
            2: FlexColumnWidth(0.8), // Maidens
            3: FlexColumnWidth(1), // Runs
            4: FlexColumnWidth(0.8), // Wickets
            5: FlexColumnWidth(1), // Economy
          },
          children: [
            _buildTableRow(['Bowler', 'O', 'M', 'R', 'W', 'ECO'],
                isHeader: true),
            for (var bowler in bowlingData)
              _buildTableRow(
                [
                  bowler['isCurrentBowler']
                      ? "${bowler['name']} *"
                      : bowler['name'],
                  bowler['overs'],
                  bowler['maidens'],
                  bowler['runs'],
                  bowler['wickets'],
                  bowler['economy']
                ],
                isHighlighted: bowler['isCurrentBowler'],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFallOfWicketsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FALL OF WICKETS",
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 8.0),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey[700]!),
          ),
          columnWidths: const {
            0: FlexColumnWidth(3), // Player name
            1: FlexColumnWidth(1), // Score
            2: FlexColumnWidth(1), // Over
          },
          children: [
            _buildTableRow(
              ['Batsman', 'R', 'O'],
            ),
            _buildTableRow(['Manish Pandey', '45', '6.3']),
            _buildTableRow(['Devdutt Padikkal', '100', '12.4']),
            _buildTableRow(['Karun Nair', '110', '14.2']),
            _buildTableRow(['Shreyas Gopal', '120', '16.5']),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, bool isHighlighted = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            cell,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: isHeader
                  ? Colors.grey[400]
                  : isHighlighted
                      ? Theme.of(context).primaryColor
                      : Colors.white,
              fontSize: isHeader ? 14.0 : 15.0,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
