// To parse this JSON data, do
//
//     final contestFeedModel = contestFeedModelFromJson(jsonString);

import 'dart:convert';

ContestFeedModel contestFeedModelFromJson(String str) => ContestFeedModel.fromJson(json.decode(str));

String contestFeedModelToJson(ContestFeedModel data) => json.encode(data.toJson());

class ContestFeedModel {
  bool status;
  String message;
  Data data;

  ContestFeedModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContestFeedModel.fromJson(Map<String, dynamic> json) => ContestFeedModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  int categoryId;
  int mediaType;
  String title;
  String poster;
  DateTime startDate;
  DateTime voteDate;
  DateTime endDate;
  String contestDesc;
  String megaAuditionDesc;
  DateTime createdAt;
  DateTime updatedAt;
  List<ContestMedia> contestMedia;

  Data({
    required this.id,
    required this.categoryId,
    required this.mediaType,
    required this.title,
    required this.poster,
    required this.startDate,
    required this.voteDate,
    required this.endDate,
    required this.contestDesc,
    required this.megaAuditionDesc,
    required this.createdAt,
    required this.updatedAt,
    required this.contestMedia,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryId: json["category_id"],
    mediaType: json["media_type"],
    title: json["title"],
    poster: json["poster"],
    startDate: DateTime.parse(json["start_date"]),
    voteDate: DateTime.parse(json["vote_date"]),
    endDate: DateTime.parse(json["end_date"]),
    contestDesc: json["contest_desc"],
    megaAuditionDesc: json["mega_audition_desc"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    contestMedia: List<ContestMedia>.from(json["contest_media"].map((x) => ContestMedia.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "media_type": mediaType,
    "title": title,
    "poster": poster,
    "start_date": startDate.toIso8601String(),
    "vote_date": voteDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "contest_desc": contestDesc,
    "mega_audition_desc": megaAuditionDesc,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "contest_media": List<dynamic>.from(contestMedia.map((x) => x.toJson())),
  };
}

class ContestMedia {
  int id;
  int contestId;
  int authId;
  int profileId;
  String? contestantID;

  int totalVotes;
  String media;
  int mediaType;
  String thumbnail;
  int status;
  String moveStatus;
  DateTime createdAt;
  DateTime updatedAt;
  bool isVoted; // New boolean variable for isVoted
  User user;
  Profile profile;

  ContestMedia({
    required this.id,
    required this.contestId,
    required this.totalVotes,
    required this.authId,
    required this.profileId,
    required this.media,
    required this.mediaType,
    required this.thumbnail,
    required this.status,
    required this.moveStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.isVoted, // Updated constructor
    required this.user,
    required this.profile,
    this.contestantID,

  });

  factory ContestMedia.fromJson(Map<String, dynamic> json) => ContestMedia(
      id: json["id"],
      contestId: json["contest_id"],
      authId: json["auth_id"],
      totalVotes: json["totalVotes"],
      profileId: json["profile_id"],
      media: json["media"],
      mediaType: json["media_type"],
      thumbnail: json["thumbnail"],
      status: json["status"],
      moveStatus: json["move_status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isVoted: json["isVoted"], // Parsing the isVoted value from JSON
      user: User.fromJson(json["user"]),
      profile: Profile.fromJson(json["profile"]),
      contestantID: json['contestant_id']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contest_id": contestId,
    "auth_id": authId,
    "profile_id": profileId,
    "totalVotes": totalVotes,
    "media": media,
    "media_type": mediaType,
    "thumbnail": thumbnail,
    "status": status,
    "move_status": moveStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "isVoted": isVoted, // Adding isVoted to the JSON map
    "user": user.toJson(),
    "profile": profile.toJson(),
    "contestant_id":contestantID
  };
}

class Profile {
  int id;
  String userId;
  String profession;
  dynamic dob;
  String industry;
  String state;
  dynamic district;
  String? profilePhoto; // Marked as nullable
  dynamic profileWallpaper;
  dynamic aboutMe;
  dynamic celebrityId;
  dynamic celebrityName;
  dynamic facebook;
  dynamic twitter;
  dynamic linkedin;
  dynamic instagram;
  DateTime createdAt;
  DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.profession,
    required this.dob,
    required this.industry,
    required this.state,
    required this.district,
    this.profilePhoto, // No longer required, since it's nullable
    required this.profileWallpaper,
    required this.aboutMe,
    required this.celebrityId,
    required this.celebrityName,
    required this.facebook,
    required this.twitter,
    required this.linkedin,
    required this.instagram,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    userId: json["user_id"],
    profession: json["profession"],
    dob: json["dob"],
    industry: json["industry"],
    state: json["state"],
    district: json["district"],
    profilePhoto: json["profile_photo"], // Allow null values
    profileWallpaper: json["profile_wallpaper"],
    aboutMe: json["about_me"],
    celebrityId: json["celebrity_id"],
    celebrityName: json["celebrity_name"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    instagram: json["instagram"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "profession": profession,
    "dob": dob,
    "industry": industry,
    "state": state,
    "district": district,
    "profile_photo": profilePhoto, // Allow null values
    "profile_wallpaper": profileWallpaper,
    "about_me": aboutMe,
    "celebrity_id": celebrityId,
    "celebrity_name": celebrityName,
    "facebook": facebook,
    "twitter": twitter,
    "linkedin": linkedin,
    "instagram": instagram,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String type;
  String phone;
  dynamic pincode;
  dynamic inPhoneDirectory;
  dynamic subType;
  String status;
  int fanFlag;
  int isCelebrity;
  int contactVisibility;
  int isFavourite;
  dynamic createdBy;
  int role;
  int isLogout;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.phone,
    required this.pincode,
    required this.inPhoneDirectory,
    required this.subType,
    required this.status,
    required this.fanFlag,
    required this.isCelebrity,
    required this.contactVisibility,
    required this.isFavourite,
    required this.createdBy,
    required this.role,
    required this.isLogout,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    type: json["type"],
    phone: json["phone"],
    pincode: json["pincode"],
    inPhoneDirectory: json["in_phone_directory"],
    subType: json["sub_type"],
    status: json["status"],
    fanFlag: json["fan_flag"],
    isCelebrity: json["is_celebrity"],
    contactVisibility: json["contact_visibility"],
    isFavourite: json["is_favourite"],
    createdBy: json["created_by"],
    role: json["role"],
    isLogout: json["isLogout"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "type": type,
    "phone": phone,
    "pincode": pincode,
    "in_phone_directory": inPhoneDirectory,
    "sub_type": subType,
    "status": status,
    "fan_flag": fanFlag,
    "is_celebrity": isCelebrity,
    "contact_visibility": contactVisibility,
    "is_favourite": isFavourite,
    "created_by": createdBy,
    "role": role,
    "isLogout": isLogout,
  };
}
