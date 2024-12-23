import 'dart:convert';

UserProfileModel profiledataFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String profiledataToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  bool status;
  String message;
  Data data;

  UserProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
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
  String type;
  String name;
  String phone;
  String? email;  // Made nullable
  String profession;
  String industry;
  String state;
  String? profilePhoto;
  String? coverImage1;
  String? coverImage2;
  String? coverImage3;
  String? coverImage4;
  String? coverImage5;  // Made nullable
  String? coverImage6;  // Made nullable
  List<DigitalTheatre> digitalTheatre;

  Data({
    required this.id,
    required this.type,
    required this.name,
    required this.phone,
    this.email,
    required this.profession,
    required this.industry,
    required this.state,
    this.profilePhoto,
    this.coverImage1,
    this.coverImage2,
    this.coverImage3,
    this.coverImage4,
    this.coverImage5,
    this.coverImage6,
    required this.digitalTheatre,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    profession: json["profession"],
    industry: json["industry"],
    state: json["state"],
    profilePhoto: json["profile_photo"],
    coverImage1: json["cover_image_1"],
    coverImage2: json["cover_image_2"],
    coverImage3: json["cover_image_3"],
    coverImage4: json["cover_image_4"],
    coverImage5: json["cover_image_5"],
    coverImage6: json["cover_image_6"],
    digitalTheatre: List<DigitalTheatre>.from(json["digital_theatre"].map((x) => DigitalTheatre.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "phone": phone,
    "email": email,
    "profession": profession,
    "industry": industry,
    "state": state,
    "profile_photo": profilePhoto,
    "cover_image_1": coverImage1,
    "cover_image_2": coverImage2,
    "cover_image_3": coverImage3,
    "cover_image_4": coverImage4,
    "cover_image_5": coverImage5,
    "cover_image_6": coverImage6,
    "digital_theatre": List<dynamic>.from(digitalTheatre.map((x) => x.toJson())),
  };
}

class DigitalTheatre {
  int id;
  int uploadType;

  String title;
  String poster;
  int year;
  dynamic rating;

  int languageId;


  int status;
  String userType;
  int userId;
  int step;
  DateTime createdAt;
  DateTime updatedAt;

  DigitalTheatre({
    required this.id,
    required this.uploadType,

    required this.title,
    required this.poster,
    required this.year,

    required this.rating,

    required this.languageId,

    required this.status,
    required this.userType,
    required this.userId,
    required this.step,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DigitalTheatre.fromJson(Map<String, dynamic> json) => DigitalTheatre(
    id: json["id"],
    uploadType: json["upload_type"],

    title: json["title"],
    poster: json["poster"],
    year: json["year"],
    rating: json["rating"],
    languageId: json["language_id"],

    status: json["status"],
    userType: json["user_type"],
    userId: json["user_id"],
    step: json["step"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "upload_type": uploadType,

    "title": title,
    "poster": poster,
    "year": year,
    "rating": rating,
    "language_id": languageId,

    "status": status,
    "user_type": userType,
    "user_id": userId,
    "step": step,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
