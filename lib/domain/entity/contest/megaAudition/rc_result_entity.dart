import 'package:filmox_clean_architecture/core/utils/urls.dart';

class RcResultEntity {
  String id;
  String authId;
  String contestId;
  String mediaId;
  bool isSelectedByJudge;
  bool isTopVoted;
  bool isVideo;
  String? media;
  String? judgeReview;
  String totalVotes;
  String userName;
  String userPicture;
  RcResultEntity(
      {required this.id,
      required this.authId,
      required this.contestId,
      required this.mediaId,
      required this.isSelectedByJudge,
      required this.isTopVoted,
        required this.isVideo,
      required String media,
       this.judgeReview,
      required this.totalVotes,
      required this.userName,
      required this.userPicture,
      }): media = isVideo ? UrlStrings.videoUrl + media : UrlStrings.imageUrl + media;
}
