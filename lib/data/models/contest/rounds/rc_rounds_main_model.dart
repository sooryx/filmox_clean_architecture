// To parse this JSON data, do
//
//     final rcRoundsFeedModel = rcRoundsFeedModelFromJson(jsonString);

import 'dart:convert';

RcRoundsModel rcRoundsFeedModelFromJson(String str) => RcRoundsModel.fromJson(json.decode(str));

String rcRoundsFeedModelToJson(RcRoundsModel data) => json.encode(data.toJson());

class RcRoundsModel {
  bool status;
  String message;
  List<Datum> data;

  RcRoundsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RcRoundsModel.fromJson(Map<String, dynamic> json) => RcRoundsModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int roundId;
  int contestId;
  int mediaType;
  int roundNumber;
  String roundType;
  String title;
  String poster;
  DateTime startDate;
  DateTime voteDate;
  DateTime endDate;
  String roundDescription;
  String megaRoundDescription;
  int isWildcard;
  int isFinal;
  int isGuest;
  int isFinished;
  bool isActive;
  bool isEligible;
  bool isContestant;
  List<UserMedia> userMedia;

  Datum({
    required this.roundId,
    required this.contestId,
    required this.mediaType,
    required this.roundNumber,
    required this.roundType,
    required this.title,
    required this.poster,
    required this.startDate,
    required this.voteDate,
    required this.endDate,
    required this.roundDescription,
    required this.megaRoundDescription,
    required this.isWildcard,
    required this.isFinal,
    required this.isGuest,
    required this.isFinished,
    required this.isActive,
    required this.isEligible,
    required this.isContestant,
    required this.userMedia,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    roundId: json["round_id"],
    contestId: json["contest_id"],
    mediaType: json["media_type"],
    roundNumber: json["round_number"],
    roundType: json["round_type"],
    title: json["title"],
    poster: json["poster"],
    startDate: DateTime.parse(json["start_date"]),
    voteDate: DateTime.parse(json["vote_date"]),
    endDate: DateTime.parse(json["end_date"]),
    roundDescription: json["round_description"],
    megaRoundDescription: json["mega_round_description"],
    isWildcard: json["is_wildcard"],
    isFinal: json["is_final"],
    isGuest: json["is_guest"],
    isFinished: json["is_finished"],
    isActive: json["is_active"],
    isEligible: json["is_eligible"],
    isContestant: json["is_contestant"],
    userMedia: List<UserMedia>.from(json["user_media"].map((x) => UserMedia.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "round_id": roundId,
    "contest_id": contestId,
    "media_type": mediaType,
    "round_number": roundNumber,
    "round_type": roundType,
    "title": title,
    "poster": poster,
    "start_date": startDate.toIso8601String(),
    "vote_date": voteDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "round_description": roundDescription,
    "mega_round_description": megaRoundDescription,
    "is_wildcard": isWildcard,
    "is_final": isFinal,
    "is_guest": isGuest,
    "is_finished": isFinished,
    "is_active": isActive,
    "is_eligible": isEligible,
    "is_contestant": isContestant,
    "user_media": List<dynamic>.from(userMedia.map((x) => x.toJson())),
  };
}


class UserMedia {
  int roundMediaId;
  String media;
  int mediaType;
  String thumbnail;
  int status;

  UserMedia({
    required this.roundMediaId,
    required this.media,
    required this.mediaType,
    required this.thumbnail,
    required this.status,
  });

  factory UserMedia.fromJson(Map<String, dynamic> json) => UserMedia(
    roundMediaId: json["round_media_id"],
    media: json["media"],
    mediaType: json["media_type"],
    thumbnail: json["thumbnail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "round_media_id": roundMediaId,
    "media": media,
    "media_type": mediaType,
    "thumbnail": thumbnail,
    "status": status,
  };
}
