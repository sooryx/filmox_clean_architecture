import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/contest/megaAudition/contest_feed/contest_feed_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_feed_entity.dart';
import 'package:flutter/cupertino.dart';

class RcFeedProvider with ChangeNotifier {
  final ContestFeedRepo _contestFeedRepo = ContestFeedRepo();

  ContestFeedEntity? _contestFeedEntity;

  ContestFeedEntity? get contestFeedEntity => _contestFeedEntity;

  DefaultPageStatus _pageStatus = DefaultPageStatus.initial;

  DefaultPageStatus get pageStatus => _pageStatus;


  Future<void> fetchContestFeedItems({required String contestID}) async {
    _pageStatus = DefaultPageStatus.loading;
    notifyListeners(); // Notify listeners when loading begins

    try {
      final response = await _contestFeedRepo.fetchIndividualContest(contestID: contestID);
      _contestFeedEntity = response; // Set the response here
      _pageStatus = DefaultPageStatus.success;
    } catch (e) {
      _pageStatus = DefaultPageStatus.failed;
      print("Error fetching contest feed items: $e");
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  DefaultPageStatus _voteLoading = DefaultPageStatus.initial;

  DefaultPageStatus get voteLoading => _voteLoading;

  Future<String> castVotes({
    required String mediaId,
    required String contestId,
  }) async {
    _voteLoading = DefaultPageStatus.loading;
    notifyListeners();

    try {
      final successMessage = await _contestFeedRepo.castVotes(
        mediaId: mediaId,
        contestId: contestId,
      );
      _voteLoading = DefaultPageStatus.success;
      notifyListeners();
      return successMessage;
    } catch (e) {
      _voteLoading = DefaultPageStatus.failed;
      notifyListeners();
      rethrow;

    }
  }

}