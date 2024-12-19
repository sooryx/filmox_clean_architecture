import 'dart:convert';

RcMainResultsModel rcMainResultsModelFromJson(String str) => RcMainResultsModel.fromJson(json.decode(str));

String rcMainResultsModelToJson(RcMainResultsModel data) => json.encode(data.toJson());

class RcMainResultsModel {
  bool? status;
  String? message;
  List<Datum>? data;

  RcMainResultsModel({
    this.status,
    this.message,
    this.data,
  });

  factory RcMainResultsModel.fromJson(Map<String, dynamic> json) => RcMainResultsModel(
    status: json["status"] ?? false,
    message: json["message"] ?? '',
    data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : [],
  };
}

class Datum {
  int? id;
  int? authId;
  int? contestId;
  int? mediaId;
  String? selectedBy;
  String? judgeReview;
  int? reviewType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalVotes;
  Media? media;
  User? user;

  Datum({
    this.id,
    this.authId,
    this.contestId,
    this.mediaId,
    this.selectedBy,
    this.judgeReview,
    this.reviewType,
    this.createdAt,
    this.updatedAt,
    this.totalVotes,
    this.media,
    this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    authId: json["auth_id"],
    contestId: json["contest_id"],
    mediaId: json["media_id"],
    selectedBy: json["selected_by"] ?? '',
    judgeReview: json["judge_review"],
    reviewType: json["review_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    totalVotes: json["total_votes"],
    media: json["media"] != null ? Media.fromJson(json["media"]) : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "auth_id": authId,
    "contest_id": contestId,
    "media_id": mediaId,
    "selected_by": selectedBy,
    "judge_review": judgeReview,
    "review_type": reviewType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "total_votes": totalVotes,
    "media": media?.toJson(),
    "user": user?.toJson(),
  };
}

class Media {
  int? id;
  int? contestId;
  int? authId;
  int? profileId;
  String? contestantId;
  String? media;
  int? mediaType;
  String? thumbnail;
  int? status;
  String? moveStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  Media({
    this.id,
    this.contestId,
    this.authId,
    this.profileId,
    this.contestantId,
    this.media,
    this.mediaType,
    this.thumbnail,
    this.status,
    this.moveStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    contestId: json["contest_id"],
    authId: json["auth_id"],
    profileId: json["profile_id"],
    contestantId: json["contestant_id"],
    media: json["media"],
    mediaType: json["media_type"],
    thumbnail: json["thumbnail"],
    status: json["status"],
    moveStatus: json["move_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contest_id": contestId,
    "auth_id": authId,
    "profile_id": profileId,
    "contestant_id": contestantId,
    "media": media,
    "media_type": mediaType,
    "thumbnail": thumbnail,
    "status": status,
    "move_status": moveStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? phone;
  dynamic pincode;
  dynamic inPhoneDirectory;
  dynamic subType;
  String? status;
  int? fanFlag;
  int? isCelebrity;
  int? contactVisibility;
  int? isFavourite;
  dynamic createdBy;
  int? role;
  int? isLogout;
  Profile? profile;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.phone,
    this.pincode,
    this.inPhoneDirectory,
    this.subType,
    this.status,
    this.fanFlag,
    this.isCelebrity,
    this.contactVisibility,
    this.isFavourite,
    this.createdBy,
    this.role,
    this.isLogout,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    profile: json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
    "profile": profile?.toJson(),
  };
}

class Profile {
  int? id;
  String? userId;
  String? profession;
  dynamic dob;
  String? industry;
  String? state;
  dynamic district;
  String? profilePhoto;
  dynamic profileWallpaper;
  dynamic aboutMe;
  dynamic celebrityId;
  dynamic celebrityName;
  dynamic facebook;
  dynamic twitter;
  dynamic linkedin;
  dynamic instagram;
  DateTime? createdAt;
  DateTime? updatedAt;

  Profile({
    this.id,
    this.userId,
    this.profession,
    this.dob,
    this.industry,
    this.state,
    this.district,
    this.profilePhoto,
    this.profileWallpaper,
    this.aboutMe,
    this.celebrityId,
    this.celebrityName,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    userId: json["user_id"],
    profession: json["profession"],
    dob: json["dob"],
    industry: json["industry"],
    state: json["state"],
    district: json["district"],
    profilePhoto: json["profile_photo"],
    profileWallpaper: json["profile_wallpaper"],
    aboutMe: json["about_me"],
    celebrityId: json["celebrity_id"],
    celebrityName: json["celebrity_name"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    instagram: json["instagram"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "profession": profession,
    "dob": dob,
    "industry": industry,
    "state": state,
    "district": district,
    "profile_photo": profilePhoto,
    "profile_wallpaper": profileWallpaper,
    "about_me": aboutMe,
    "celebrity_id": celebrityId,
    "celebrity_name": celebrityName,
    "facebook": facebook,
    "twitter": twitter,
    "linkedin": linkedin,
    "instagram": instagram,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

