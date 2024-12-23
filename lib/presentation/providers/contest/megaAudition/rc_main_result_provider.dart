import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/contest/megaAudition/contest_result/contest_result_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_result_entity.dart';
import 'package:flutter/cupertino.dart';

class RcMainResultProvider with ChangeNotifier {
  final ContestResultRepo _contestResultRepo = ContestResultRepo();
  DefaultPageStatus _status = DefaultPageStatus.initial;

  DefaultPageStatus get status => _status;

  List<RcResultEntity> _resultsList = [];

  List<RcResultEntity> get resultsList => _resultsList;

  Future<void> fetchResults({required String contestID}) async {
    _status = DefaultPageStatus.loading;
    try {
      _resultsList =
          await _contestResultRepo.fetchResults(contestID: contestID);
    } catch (e) {
      _status = DefaultPageStatus.failed;

      rethrow;
    } finally {
      _status = DefaultPageStatus.success;
    }
  }
}
