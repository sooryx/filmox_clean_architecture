import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WatchPartyScreen extends StatefulWidget {
  @override
  _WatchPartyScreenState createState() => _WatchPartyScreenState();
}

class _WatchPartyScreenState extends State<WatchPartyScreen> {
  String? _selectedTeam;
  Map<String, int> voteCount = {
    'KAR - A': 72,
    'KAR - B': 38,
  };

  // Function to handle vote submission
  void _submitVote() {
    if (_selectedTeam != null) {
      setState(() {
        isAnswered = true;
        voteCount[_selectedTeam!] = voteCount[_selectedTeam!]! + 1;
      });
    }
  }

  // Function to build the statistics chart
  Widget _buildVoteChart() {
    return BarChart(
      BarChartData(
        backgroundColor: Theme.of(context).disabledColor,
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: voteCount['KAR - A']!.toDouble(),
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: voteCount['KAR - B']!.toDouble(),
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value == 0 ? 'KAR - A' : 'KAR - B',
            );
          },
        ))),
      ),
    );
  }

  bool isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Karnataka A Score
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KAR-A',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 28),
                    ),
                    Text(
                      '120-4 (16.5)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                // Karnataka B Yet to Bat
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KAR-B',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 28),
                    ),
                    Text(
                      'Yet to Bat',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          if (isAnswered)
            Column(
              children: [
                Text(
                  'Vote Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 320, child: _buildVoteChart()),
              ],
            ),
          if (!isAnswered)
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).primaryColorDark),
              child: Column(
                children: [
                  Text(
                    'Which team will win?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    activeColor: Theme.of(context).cardColor,
                    selectedTileColor: Theme.of(context).primaryColorDark,
                    title: Text(
                      'KAR - A',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 22),
                    ),
                    value: 'KAR - A',
                    groupValue: _selectedTeam,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedTeam = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    activeColor: Theme.of(context).cardColor,
                    selectedTileColor: Theme.of(context).primaryColorDark,
                    title: Text(
                      'KAR - B',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 22),
                    ),
                    value: 'KAR - B',
                    groupValue: _selectedTeam,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedTeam = value;
                      });
                    },
                  ),
                  CommonWidgets.customButton(
                      context: context,
                      text: "Submit",
                      onPressed: _submitVote,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).primaryColorDark),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
