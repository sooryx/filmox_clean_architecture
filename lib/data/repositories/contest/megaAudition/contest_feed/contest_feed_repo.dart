// ignore_for_file: unused_import

import 'dart:convert';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/contest/megaAudition/rc_contest_feed_model/rc_feed_main/rc_contest_feed_model.dart';
import 'package:filmox_clean_architecture/data/models/contest/megaAudition/rc_contest_feed_model/rc_feed_results/rc_feed_results.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';

class ContestFeedRepo {
  final ApiService _apiService = ApiService();

  Future<ContestFeedEntity> fetchIndividualContest({required String contestID}) async {
    try {
      Map<String, dynamic> textBody = {'contest_id': contestID};
      final responseFeed = await _apiService.post('/fetch_rc_individual_contest_media', textBody);
      final responseResults = await _apiService.post('/mostVoted', textBody);

      // Parse and map to entity
      ContestFeedModel dataModel = ContestFeedModel.fromJson(responseFeed);
      RCLiveResults resultsModel = RCLiveResults.fromJson(responseResults);
      return ContestFeedEntity(
        title: dataModel.data.title,
        poster: dataModel.data.poster,
        contestID: dataModel.data.id.toString(),
        startDate: dataModel.data.startDate,
        voteDate: dataModel.data.voteDate,
        endDate: dataModel.data.endDate,
        contestMedias: dataModel.data.contestMedia.map((item) => ContestMediaitemsEntity(
          userName: item.user.name,
          mediaID: item.id.toString(),
          contestID: dataModel.data.id.toString(),
          mediaType: item.mediaType,
          isVoted: item.isVoted,
          contestantID: item.user.id.toString(),
          userImage: item.profile.profilePhoto ?? '',
          thumbnail: item.thumbnail,
          file: item.media,
          createdDate: item.createdAt,
          totalVotes: item.totalVotes.toString(),
        )).toList(),
        results: resultsModel.voteDetails.map((item) => UserEntityContestFeed(
          name: item.userName,
          image: item.userProfile,
          totalVotes: item.totalVotes.toString(),
        )).toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch contest data: $e');
    }
  }

  Future<String> castVotes({
    required String mediaId,
    required String contestId,
  }) async {
    String endpoint = '/rc_cast_vote';
    Map<String, String> data = {'media_id': mediaId, 'contest_id': contestId};

    try {
      // Assuming _apiService.post() returns the decoded response as Map<String, dynamic>
      final response = await _apiService.post(endpoint, data);

      // Use response directly, as it's already a Map<String, dynamic>
      if (response['status'] == 200 || response['status'] == 201) {
        if (response.containsKey('message')) {
          return response['message'];
        } else {
          return 'Vote cast successfully!';
        }
      } else {
        // Check for the specific duplicate vote error
        if (response['data'] != null &&
            response['data']['vote'] != null &&
            response['data']['vote'].contains(
                'You have already voted for another media. Please remove your previous vote before voting again.')) {
          throw Exception("Please remove your previous vote before voting again.");
        } else {
          throw Exception('Failed to cast vote');
        }
      }
    } catch (e) {
      throw Exception('Error casting vote: $e');
    }
  }


}
