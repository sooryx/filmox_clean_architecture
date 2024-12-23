
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/contest/megaAudition/contest_main/contest_main_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_main_entity.dart';
import 'package:flutter/material.dart';

class RcMainProvider with ChangeNotifier {
  ContestMainRepo _contestRepo = ContestMainRepo();

  ContestMainRepo get contestRepo => _contestRepo;
  List<ContestEntity> _liveContests = [];
  List<ContestEntity> _upcomingContests = [];
  List<ContestEntity> _finishedContests = [];
  DefaultPageStatus _status = DefaultPageStatus.initial;
  String _errorMessage = '';

  Future<void> fetchContests() async {
    _status = DefaultPageStatus.loading;
    notifyListeners();
    try {
      final dataModel = await _contestRepo.fetchContests();
      _liveContests = await _contestRepo.liveContestList(dataModel);
      _upcomingContests = await _contestRepo.upcomingContestList(dataModel);
      _finishedContests = await _contestRepo.finishedContestList(dataModel);
    } on Exception catch (e) {
      _errorMessage = 'Failed to fetch tabs: $e';
      _status = DefaultPageStatus.failed;
    } finally {
      _status = DefaultPageStatus.success;
      notifyListeners();
    }
  }

  List<ContestEntity> get liveContests => _liveContests;

  List<ContestEntity> get upcomingContests => _upcomingContests;

  List<ContestEntity> get finishedContests => _finishedContests;

  DefaultPageStatus get status => _status;

  String get errorMessage => _errorMessage;



}
