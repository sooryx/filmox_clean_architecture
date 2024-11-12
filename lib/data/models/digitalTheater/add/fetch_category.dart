// To parse this JSON data, do
//
//     final fetchProgressSfUpload = fetchProgressSfUploadFromJson(jsonString);

import 'dart:convert';

FetchCategory fetchProgressSfUploadFromJson(String str) => FetchCategory.fromJson(json.decode(str));

String fetchProgressSfUploadToJson(FetchCategory data) => json.encode(data.toJson());

class FetchCategory {
  bool status;
  String message;
  Data data;

  FetchCategory({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FetchCategory.fromJson(Map<String, dynamic> json) => FetchCategory(
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
  List<Category> categories;
  List<Category> genres;
  List<Category> languages;
  int step;
  int? dtID;

  Data({
    required this.categories,
    required this.genres,
    required this.languages,
    this.step = 0, // Initialize step with a default value of 0
    this.dtID,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    genres: List<Category>.from(json["genres"].map((x) => Category.fromJson(x))),
    languages: List<Category>.from(json["languages"].map((x) => Category.fromJson(x))),
    step: json["dt_info"] != null ? json["dt_info"]["step"] ?? 0 : 0, // Null check for dt_info
    dtID: json["dt_info"] != null ? json["dt_info"]["id"] : null, // Null check for dt_info
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
    "step": step,
    "dt_id": dtID,
  };
}


class Category {
  int id;
  String? category;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String? genre;
  String? language;
  int step; // Added step property

  Category({
    required this.id,
    this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.genre,
    this.language,
    this.step = 0, // Initialize step with a default value of 0
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    category: json["category"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    genre: json["genre"],
    language: json["language"],
    step: json["step"] ?? 0, // Assign 0 if step is null or not provided
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "genre": genre,
    "language": language,
    "step": step, // Adding step to JSON
  };
}
