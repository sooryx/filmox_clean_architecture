// To parse this JSON data, do
//
//     final rcMainDataModel = rcMainDataModelFromJson(jsonString);

import 'dart:convert';

RcMainDataModel rcMainDataModelFromJson(String str) => RcMainDataModel.fromJson(json.decode(str));

String rcMainDataModelToJson(RcMainDataModel data) => json.encode(data.toJson());

class RcMainDataModel {
  bool? status;
  String? message;
  Data? data;

  RcMainDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory RcMainDataModel.fromJson(Map<String, dynamic> json) => RcMainDataModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<RcCategory>? liveCategories;
  List<RcCategory>? upcomingCategories;
  List<RcCategory>? finishedCategories;

  Data({
    this.liveCategories,
    this.upcomingCategories,
    this.finishedCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    liveCategories: json["live_categories"] == null ? [] : List<RcCategory>.from(json["live_categories"]!.map((x) => RcCategory.fromJson(x))),
    upcomingCategories: json["upcoming_categories"] == null ? [] : List<RcCategory>.from(json["upcoming_categories"]!.map((x) => RcCategory.fromJson(x))),
    finishedCategories: json["finished_categories"] == null ? [] : List<RcCategory>.from(json["finished_categories"]!.map((x) => RcCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "live_categories": liveCategories == null ? [] : List<dynamic>.from(liveCategories!.map((x) => x.toJson())),
    "upcoming_categories": upcomingCategories == null ? [] : List<dynamic>.from(upcomingCategories!.map((x) => x.toJson())),
    "finished_categories": finishedCategories == null ? [] : List<dynamic>.from(finishedCategories!.map((x) => x.toJson())),
  };
}

class RcCategory {
  int? id;
  String? title;
  int? status;
  List<Contest>? contests;

  RcCategory({
    this.id,
    this.title,
    this.status,
    this.contests,
  });

  factory RcCategory.fromJson(Map<String, dynamic> json) => RcCategory(
    id: json["id"],
    title: json["title"],
    status: json["status"],
    contests: json["contests"] == null ? [] : List<Contest>.from(json["contests"]!.map((x) => Contest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
    "contests": contests == null ? [] : List<dynamic>.from(contests!.map((x) => x.toJson())),
  };
}

class Contest {
  int? id;
  int? categoryId;
  int? mediaType;
  String? title;
  String? poster;
  DateTime? startDate;
  DateTime? voteDate;
  DateTime? endDate;
  String? contestDesc;
  String? megaAuditionDesc;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? is_published;
  List<Banner>? banners;
  List<Guest>? guests;
  List<UserMedia>? userMedia;


  Contest({
    this.id,
    this.categoryId,
    this.mediaType,
    this.title,
    this.poster,
    this.startDate,
    this.voteDate,
    this.endDate,
    this.contestDesc,
    this.megaAuditionDesc,
    this.createdAt,
    this.updatedAt,
    this.banners,
    this.guests,
    this.userMedia,
    this.is_published,
  });

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
    id: json["id"],
    categoryId: json["category_id"],
    mediaType: json["media_type"],
    title: json["title"],
    poster: json["poster"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    voteDate: json["vote_date"] == null ? null : DateTime.parse(json["vote_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    contestDesc: json["contest_desc"],
    megaAuditionDesc: json["mega_audition_desc"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    banners: json["banners"] == null ? [] : List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
    guests: json["guests"] == null ? [] : List<Guest>.from(json["guests"].map((x) => Guest.fromJson(x))),
    userMedia: List<UserMedia>.from(json["user_media"].map((x) => UserMedia.fromJson(x))),
    is_published: json["is_published"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "media_type": mediaType,
    "title": title,
    "poster": poster,
    "start_date": startDate?.toIso8601String(),
    "vote_date": voteDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "contest_desc": contestDesc,
    "mega_audition_desc": megaAuditionDesc,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "banners": banners?.map((x) => x.toJson()).toList(),
    "guests": guests?.map((x) => x.toJson()).toList(),
    "user_media": userMedia?.map((x) => x.toJson()).toList(),
    "is_published": is_published,



  };
}

class Banner {
  int? id;
  int? bpId;
  String? banner;
  int? type;
  int? status;

  Banner({
    this.id,
    this.bpId,
    this.banner,
    this.type,
    this.status,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    id: json["id"],
    bpId: json["bp_id"],
    banner: json["banner"],
    type: json["type"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bp_id": bpId,
    "banner": banner,
    "type": type,
    "status": status,
  };
}

class Guest {
  int? id;
  String? name;
  String? image;

  Guest({
    this.id,
    this.name,
    this.image,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
class UserMedia {
  int id;
  String media;
  int mediaType;
  String thumbnail;
  int status;

  UserMedia({
    required this.id,
    required this.media,
    required this.mediaType,
    required this.thumbnail,
    required this.status,
  });

  factory UserMedia.fromJson(Map<String, dynamic> json) => UserMedia(
    id: json["id"],
    media: json["media"],
    mediaType: json["media_type"],
    thumbnail: json["thumbnail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media": media,
    "media_type": mediaType,
    "thumbnail": thumbnail,
    "status": status,
  };
}
