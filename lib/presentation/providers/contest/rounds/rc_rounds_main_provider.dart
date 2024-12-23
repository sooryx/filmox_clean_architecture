// ignore_for_file: unused_field

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/contest/rounds/rounds_db_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/rounds/rounds_entity.dart';
import 'package:flutter/cupertino.dart';

class RcRoundsMainProvider with ChangeNotifier {
  final RoundsDbRepo _roundsDbRepo = RoundsDbRepo();

  DefaultPageStatus get status => _status;
  DefaultPageStatus _status = DefaultPageStatus.initial;
  List<RoundsEntity> _roundsEntity = [];
  RoundsEntity? _activeRound;

  Future<void> fetchRounds({
    required String contestID
  }) async {
    try {
      _status = DefaultPageStatus.loading;
      notifyListeners();

      _roundsEntity =
      await _roundsDbRepo.fetchRoundDetails(contestId: contestID);
      fetchActiveRound();
    } catch (e) {
      rethrow;
    } finally {
      _status = DefaultPageStatus.success;
      notifyListeners();
    }
  }


  fetchActiveRound() {
    _activeRound = _roundsEntity.firstWhere(
          (round) => round.isActive,
      orElse: () {
        return _roundsEntity.first;
      },
    );
  }

  List<RoundsEntity> get roundsEntity => _roundsEntity;

  RoundsEntity? get activeRound => _activeRound;
}
