import 'package:filmox_clean_architecture/core/utils/urls.dart';

class RoundsEntity {
  String contestID;
  String roundID;
  bool isVideo;
  int roundNumber;
  String title;
  String poster;
  DateTime startDate;
  DateTime voteDate;
  DateTime endDate;
  String roundDescription;
  String megaRoundDescription;
  bool isActive;
  UserMediaEntity userMedia;

  RoundsEntity(
      {required this.contestID,
      required this.roundID,
      required this.isVideo,
      required this.roundNumber,
      required this.title,
      required this.poster,
      required this.startDate,
      required this.voteDate,
      required this.endDate,
      required this.roundDescription,
      required this.megaRoundDescription,
      required this.isActive,
      required this.userMedia,


      });
}

class UserMediaEntity {
  int roundMediaId;
  String? media;
  bool isVideo;
  String? thumbnail;
  int status;

  UserMediaEntity(
      {required this.roundMediaId,
      required String media,
      required this.isVideo,
      required String thumbnail,
      required this.status}):media =isVideo? UrlStrings.videoUrl + media : UrlStrings.imageUrl+media
  ;
}
