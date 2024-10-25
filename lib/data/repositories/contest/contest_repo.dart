import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/contest/rc_contest_model.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/contest_entity.dart';

class ContestRepo {
  ApiService _apiService = ApiService();

  Future<RcMainDataModel> fetchContests() async {
    final response = await _apiService.post('/rc_fetch_contests', {});
    final dataModel = RcMainDataModel.fromJson(response);
    return dataModel;
  }

  Future<List<ContestEntity>> liveContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.liveCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    categoryName: category.title ?? '',
                    contestID: contest.id ?? 0,
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }

  Future<List<ContestEntity>> upcomingContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.upcomingCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    categoryName: category.title ?? '',
                    contestID: contest.id ?? 0,
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }

  Future<List<ContestEntity>> finishedContestList(RcMainDataModel dataModel) {
    return Future.value(
      dataModel.data!.finishedCategories
          ?.expand(
              (category) => category.contests!.map((contest) => ContestEntity(
                    contestID: contest.id ?? 0,
                    categoryName: category.title ?? '',
                    name: contest.title ?? '',
                    poster: contest.poster ?? '',
                    startDate: contest.startDate ?? DateTime.now(),
                    voteDate: contest.voteDate ?? DateTime.now(),
                    endDate: contest.endDate ?? DateTime.now(),
                    contestDesc: contest.contestDesc ?? '',
                    megaAuditionDesc: contest.megaAuditionDesc ?? '',
                  )))
          .toList(),
    );
  }
}
