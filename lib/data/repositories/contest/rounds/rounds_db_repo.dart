import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/contest/rounds/rc_rounds_main_model.dart';
import 'package:filmox_clean_architecture/domain/entity/contest/rounds/rounds_entity.dart';

class RoundsDbRepo {
  final ApiService _apiService = ApiService();

  Future<List<RoundsEntity>> fetchRoundDetails(
      {required String contestId}) async {
    final body = {
      'contest_id': contestId,
    };
    final response = await _apiService.post('/rc_fetch_round', body);
    final dataModel = RcRoundsModel.fromJson(response);
    final rounds = dataModel.data;

    return rounds
        .map((item) => RoundsEntity(
            contestID: item.contestId.toString(),
            roundID: item.roundId.toString(),
            isVideo: item.mediaType == 1,
            roundNumber: item.roundNumber,
            title: item.title,
            poster: item.title,
            startDate: item.startDate,
            voteDate: item.voteDate,
            endDate: item.endDate,
            roundDescription: item.roundDescription,
            megaRoundDescription: item.megaRoundDescription,
            isActive: item.isActive,
            userMedia: UserMediaEntity(
                roundMediaId: item.userMedia[0].roundMediaId,
                media: item.userMedia[0].media,
                isVideo: item.userMedia[0].mediaType == 1,
                thumbnail: item.userMedia[0].thumbnail,
                status: item.userMedia[0].status)))
        .toList();
  }
}
