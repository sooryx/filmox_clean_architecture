import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/contest/megaAudition/rc_main_result_provider/rc_main_result_model.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/megaAudition/rc_result_entity.dart';

class ContestResultRepo {
  final ApiService _apiService = ApiService();

  Future<List<RcResultEntity>> fetchResults({required String contestID}) async {
    final body = {'contest_id': contestID.toString()};
    final response = await _apiService.post('/final_contestants', body);

    final dataModel = RcMainResultsModel.fromJson(response);
    final contestItems = dataModel.data ?? [];
    final List<RcResultEntity> resultEntities = contestItems.map((item) {
      return RcResultEntity(
        id: item.id.toString(),
        authId: item.authId.toString(),
        contestId: item.contestId.toString(),
        mediaId: item.mediaId.toString(),
        isSelectedByJudge: item.selectedBy == "judge",
        isTopVoted: item.selectedBy == 'vote',
        isVideo: item.media?.mediaType == 1,
        media: item.media?.media ?? '',
        totalVotes: item.totalVotes.toString(),
        userName: item.user?.name ?? '',
        userPicture: item.user?.profile?.profilePhoto ?? '',
      );
    }).toList();
    return resultEntities;
  }
}
