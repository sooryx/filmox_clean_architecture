import 'dart:convert';

UserTypeModel userTypeFromJson(String str) => UserTypeModel.fromJson(json.decode(str));

String userTypeToJson(UserTypeModel data) => json.encode(data.toJson());

class UserTypeModel {
  bool? status;
  List<Datum> data;
  String message;

  UserTypeModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) => UserTypeModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int id;
  String userType;
  String media;
  int type;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.userType,
    required this.media,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userType: json["user_type"],
    media: json["media"],
    type: json["type"],
    title: json["title"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_type": userType,
    "media": media,
    "type": type,
    "title": title,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
