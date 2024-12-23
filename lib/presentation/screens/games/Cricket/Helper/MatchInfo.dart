
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeagueDetailsScreen extends StatelessWidget {
  final String tournamentName;
  final String matchDetails;
  final String startTime;
  final String venue;
  final String team1Name;
  final String team1FlagUrl;
  final String team2Name;
  final String team2FlagUrl;
  final String tossResult;

  LeagueDetailsScreen({
    required this.tournamentName,
    required this.matchDetails,
    required this.startTime,
    required this.venue,
    required this.team1Name,
    required this.team1FlagUrl,
    required this.team2Name,
    required this.team2FlagUrl,
    required this.tossResult,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentSection(context),
            SizedBox(height: 16),
            _buildTeamsSection(context),
            SizedBox(height: 16),
            _buildMatchDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tournament',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 20.sp, color: Colors.white),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Image.network(
              'https://images.thequint.com/thequint%2F2024-03%2F3a662673-8378-415a-9e3f-a006a671a1b4%2FCCL_2024_Final.jpg?auto=format%2Ccompress&fmt=webp&width=440&w=1200',
              height: 30,
              // color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              tournamentName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 24.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teams',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 20.sp, color: Colors.white),
        ),
        SizedBox(height: 8),
        _buildTeamRow(
          context,
          "https://upload.wikimedia.org/wikipedia/en/0/0a/Royal_Challengers_Bengaluru_Logo.png",
          team1Name,
          '',
        ),
        SizedBox(height: 8),
        _buildTeamRow(
          context,
          "https://upload.wikimedia.org/wikipedia/en/thumb/2/2b/Chennai_Super_Kings_Logo.svg/1200px-Chennai_Super_Kings_Logo.svg.png",
          team2Name,
          tossResult,
        ),
        const SizedBox(height: 10.0),
        if (tossResult.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'TOSS',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        const SizedBox(height: 10.0),
        if (tossResult.isNotEmpty) ...[
          SizedBox(width: 8),
          Text(
            "Karnataka Won the toss and decided to bat",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTeamRow(
      BuildContext context, String flagUrl, String teamName, String tossInfo) {
    return Row(
      children: [
        Image.network(
          flagUrl,
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            teamName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 18.sp, color: Colors.white),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 16,
        ),
      ],
    );
  }

  Widget _buildMatchDetailsSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Match Details',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 20.sp, color: Colors.white),
        ),
        SizedBox(height: 8),
        _buildDetailRow(context, 'Match', matchDetails),
        _buildDetailRow(context, 'Match Start Time', startTime),
        _buildDetailRow(context, 'Stadium/Venue', venue),
      ],
    );
  }

  Widget _buildDetailRow(context, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 4),
          Text(
            detail,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 18.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
