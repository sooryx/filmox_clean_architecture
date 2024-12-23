import 'package:filmox_clean_architecture/core/utils/app_constants.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';

class ContestFeedEntity {
  String title;
  String poster;
  String contestID;
  DateTime startDate;
  DateTime voteDate;
  DateTime endDate;
  List<ContestMediaitemsEntity> contestMedias;

  List<UserEntityContestFeed> results;

  ContestFeedEntity({
    required this.title,
    required String poster,
    required this.contestID,
    required this.startDate,
    required this.voteDate,
    required this.endDate,
    required this.contestMedias,
    required this.results,
  }) : this.poster = '${UrlStrings.imageUrl}$poster';
}

class ContestMediaitemsEntity {
  String contestID;
  String mediaID;
  String contestantID;
  String userName;
  String userImage;
  String totalVotes;
  int mediaType;
  String thumbnail;
  String file;
  DateTime createdDate;
  bool isVoted;

  ContestMediaitemsEntity(
      {required this.contestID,
      required this.mediaID,
      required this.contestantID,
      required this.userName,
      required String userImage,
      required this.totalVotes,
      required String thumbnail,
      required String file,
      required this.mediaType,
      required this.createdDate,
      required this.isVoted})
      : this.thumbnail = UrlStrings.imageUrl + thumbnail,
        this.userImage = userImage != '' ?UrlStrings.imageUrl + userImage : AppConstants.filmoxLogo,
        this.file = mediaType == 1 ? UrlStrings.videoUrl + file :UrlStrings.imageUrl + file  ;
}

class UserEntityContestFeed {
  String name;
  String image;
  String totalVotes;

  UserEntityContestFeed(
      {required this.name, required String image, required this.totalVotes})
      : this.image = '${UrlStrings.imageUrl}$image'; //;
}
