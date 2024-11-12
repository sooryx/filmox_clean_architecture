
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CricketFeedScreen extends StatefulWidget {
  const CricketFeedScreen({super.key});

  @override
  State<CricketFeedScreen> createState() => _CricketFeedScreenState();
}

class _CricketFeedScreenState extends State<CricketFeedScreen>
    with TickerProviderStateMixin {
  List<Map<String, String>> _ballUpdates = [
    {
      'ball': '16.5',
      'commentary': 'Four! Shreyas Gopal drives it through covers.',
      'score': '4'
    },
    {
      'ball': '16.4',
      'commentary': 'No run, good length delivery from Prasidh Krishna.',
      'score': '0'
    },
    {
      'ball': '16.3',
      'commentary': 'SIX! Shreyas Gopal goes big, launches it over midwicket.',
      'score': '6'
    },
    {'ball': '16.2', 'commentary': '1 run, single to mid-on.', 'score': '1'},
    {
      'ball': '16.1',
      'commentary': 'Wicket! Excellent yorker by Prasidh Krishna.',
      'score': 'W'
    },
    {
      'ball': '15.6',
      'commentary': '1 run, driven down to long-off.',
      'score': '1'
    },
    {
      'ball': '15.5',
      'commentary': 'SIX! Lofted down the ground for a massive hit!',
      'score': '6'
    },
    {
      'ball': '15.4',
      'commentary': 'No run, tight line outside off, beaten.',
      'score': '0'
    },
    {
      'ball': '15.3',
      'commentary': 'Four! Flicked to the boundary through mid-wicket.',
      'score': '4'
    },
    {
      'ball': '15.2',
      'commentary': '1 run, nudged to square leg for a quick single.',
      'score': '1'
    },
    {
      'ball': '15.1',
      'commentary': 'Dot ball, yorker on middle, well blocked.',
      'score': '0'
    },
  ];

  List<bool> _isVisible = [];
  ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _isVisible = List.generate(_ballUpdates.length, (index) => false);
    _triggerAppearances();

    // Attach scroll controller listener to detect when to load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _loadMoreBalls();
      }
    });
  }

  void _triggerAppearances() {
    for (int i = 0; i < _ballUpdates.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        setState(() {
          _isVisible[i] = true;
        });
      });
    }
  }

  void _loadMoreBalls() async {
    if (!_loadingMore) {
      setState(() {
        _loadingMore = true;
      });

      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      List<Map<String, String>> moreUpdates = [
        {
          'ball': '15.0',
          'commentary': 'Dot ball, defended back to the bowler.',
          'score': '0'
        },
        {
          'ball': '14.6',
          'commentary': '1 run, steered to third man for a single.',
          'score': '1'
        },
        {
          'ball': '14.5',
          'commentary': 'Four! Slashed away over point for a boundary.',
          'score': '4'
        },
        {
          'ball': '14.4',
          'commentary': 'No run, slower delivery, missed completely.',
          'score': '0'
        },
      ];

      setState(() {
        _ballUpdates.addAll(moreUpdates);
        _isVisible.addAll(List.generate(moreUpdates.length, (index) => false));
        _loadingMore = false;

        // Trigger appearance for newly loaded items
        _triggerAppearances();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karnataka A vs Karnataka B',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KAR-A',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            '120-4 (16.5)',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'KAR-B',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            'Yet to Bat',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Ball: ${_ballUpdates.first['ball']}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _ballUpdates.first['commentary']!,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.r),
              height: 94.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.r),
                scrollDirection: Axis.horizontal,
                itemCount: _ballUpdates.length,
                itemBuilder: (context, index) {
                  final ball = _ballUpdates[index];
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getBackgroundColor(ball['score']!, context),
                    ),
                    child: Text(
                      '${ball['score']}',
                      style: TextStyle(
                        color: _getTextColor(ball['score']!, context),
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Previous Balls Section with animation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous Balls',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.r),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _ballUpdates.length,
                    itemBuilder: (context, index) {
                      final ball = _ballUpdates[index];
                      return AnimatedOpacity(
                        opacity: _isVisible[index] ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getBackgroundColor(
                                        ball['score']!, context),
                                  ),
                                  child: Text(
                                    '${ball['score']}',
                                    style: TextStyle(
                                      color: _getTextColor(
                                          ball['score']!, context),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${ball['ball']} - ${ball['commentary']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Loading indicator for fetching more data
            if (_loadingMore)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to get the background color based on score
  Color _getBackgroundColor(String score, BuildContext context) {
    if (score == '4' || score == '6') {
      return Theme.of(context).primaryColorDark;
    } else if (score == '1' || score == '2' || score == '3') {
      return Colors.white;
    } else if (score == 'W') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  // Helper function to get the text color based on score
  Color _getTextColor(String score, BuildContext context) {
    if (score == '4' || score == '6' || score == 'W') {
      return Colors.white;
    } else if (score == '1' || score == '2' || score == '3') {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
