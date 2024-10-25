// To parse this JSON data, do
//
//     final onBoardingDataModel = onBoardingDataModelFromJson(jsonString);

import 'dart:convert';

OnBoardingDataModel onBoardingDataModelFromJson(String str) => OnBoardingDataModel.fromJson(json.decode(str));

String onBoardingDataModelToJson(OnBoardingDataModel data) => json.encode(data.toJson());

class OnBoardingDataModel {
  List<Datum> data;
  String message;

  OnBoardingDataModel({
    required this.data,
    required this.message,
  });

  factory OnBoardingDataModel.fromJson(Map<String, dynamic> json) => OnBoardingDataModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int id;
  String media;
  int type;
  String description;
  int screen;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.media,
    required this.type,
    required this.description,
    required this.screen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    media: json["media"],
    type: json["type"],
    description: json["description"],
    screen: json["screen"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media": media,
    "type": type,
    "description": description,
    "screen": screen,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
