import 'dart:convert';

IndividualDTModel fetchSeasonFromJson(String str) =>
    IndividualDTModel.fromJson(json.decode(str));

String fetchSeasonToJson(IndividualDTModel data) => json.encode(data.toJson());

class IndividualDTModel {
  bool status;
  String message;
  Data data;

  IndividualDTModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory IndividualDTModel.fromJson(Map<String, dynamic> json) => IndividualDTModel(
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
  int uploadType;
  int categoryId;
  String title;
  String poster;
  int year;
  String certificate;
  dynamic rating;
  dynamic hours;
  dynamic minutes;
  int genreId;
  int languageId;
  String storyLine;
  String? trailerType;
  String? trailerMediaFile;
  String? trailerMediaLink;
  dynamic singleMediaType;
  dynamic singleMediaFile;
  dynamic singleMediaLink;
  dynamic multipleMediaId;
  int status;
  String userType;
  int userId;
  int step;
  DateTime createdAt;
  DateTime updatedAt;
  List<Cast>? cast;
  List<Cast>? crew;
  List<Season> seasons;

  Data({
    required this.id,
    required this.uploadType,
    required this.categoryId,
    required this.title,
    required this.poster,
    required this.year,
    required this.certificate,
    required this.rating,
    required this.hours,
    required this.minutes,
    required this.genreId,
    required this.languageId,
    required this.storyLine,
    this.trailerType,
    this.trailerMediaFile,
    this.trailerMediaLink,
    this.singleMediaType,
    this.singleMediaFile,
    this.singleMediaLink,
    this.multipleMediaId,
    required this.status,
    required this.userType,
    required this.userId,
    required this.step,
    required this.createdAt,
    required this.updatedAt,
    this.cast,
    this.crew,
    required this.seasons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uploadType: json["upload_type"],
    categoryId: json["category_id"],
    title: json["title"],
    poster: json["poster"],
    year: json["year"],
    certificate: json["certificate"],
    rating: json["rating"],
    hours: json["hours"],
    minutes: json["minutes"],
    genreId: json["genre_id"],
    languageId: json["language_id"],
    storyLine: json["story_line"],
    trailerType: json["trailer_type"],
    trailerMediaFile: json["trailer_media_file"],
    trailerMediaLink: json["trailer_media_link"],
    singleMediaType: json["single_media_type"],
    singleMediaFile: json["single_media_file"],
    singleMediaLink: json["single_media_link"],
    multipleMediaId: json["multiple_media_id"],
    status: json["status"],
    userType: json["user_type"],
    userId: json["user_id"],
    step: json["step"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    cast: json["cast"] != null
        ? List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x)))
        : null,
    crew: json["crew"] != null
        ? List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x)))
        : null,
    seasons:
    List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "upload_type": uploadType,
    "category_id": categoryId,
    "title": title,
    "poster": poster,
    "year": year,
    "certificate": certificate,
    "rating": rating,
    "hours": hours,
    "minutes": minutes,
    "genre_id": genreId,
    "language_id": languageId,
    "story_line": storyLine,
    "trailer_type": trailerType,
    "trailer_media_file": trailerMediaFile,
    "trailer_media_link": trailerMediaLink,
    "single_media_type": singleMediaType,
    "single_media_file": singleMediaFile,
    "single_media_link": singleMediaLink,
    "multiple_media_id": multipleMediaId,
    "status": status,
    "user_type": userType,
    "user_id": userId,
    "step": step,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "cast": cast != null
        ? List<dynamic>.from(cast!.map((x) => x.toJson()))
        : null,
    "crew": crew != null
        ? List<dynamic>.from(crew!.map((x) => x.toJson()))
        : null,
    "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
  };
}

class Cast {
  int? id;
  int? dtId;
  String name;
  String role;
  String image;
  String? userType;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Cast({
    this.id,
    this.dtId,
    required this.name,
    required this.role,
    required this.image,
    this.userType,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
    id: json["id"],
    dtId: json["dt_id"],
    name: json["name"],
    role: json["role"],
    image: json["image"],
    userType: json["user_type"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dt_id": dtId,
    "name": name,
    "role": role,
    "image": image,
    "user_type": userType,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class Season {
  int id;
  int dtId;
  String name;
  String trailerType;
  String? trailerMediaFile;
  String? trailerMediaLink;
  int year;
  int status;
  int isPublish;
  String userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Episode>? episodes;

  Season({
    required this.id,
    required this.dtId,
    required this.name,
    required this.trailerType,
    this.trailerMediaFile,
    this.trailerMediaLink,
    required this.year,
    required this.status,
    required this.userType,
    required this.isPublish,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    id: json["id"],
    dtId: json["dt_id"],
    name: json["name"],
    trailerType: json["trailer_type"],
    trailerMediaFile: json["trailer_media_file"],
    trailerMediaLink: json["trailer_media_link"],
    year: json["year"],
    status: json["status"],
    userType: json["user_type"],
    isPublish: json["is_publish"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    episodes: json["episodes"] != null
        ? List<Episode>.from(
        json["episodes"].map((x) => Episode.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dt_id": dtId,
    "name": name,
    "trailer_type": trailerType,
    "trailer_media_file": trailerMediaFile,
    "trailer_media_link": trailerMediaLink,
    "year": year,
    "status": status,
    "user_type": userType,
    "is_publish": isPublish,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "episodes": episodes != null
        ? List<dynamic>.from(episodes!.map((x) => x.toJson()))
        : null,
  };
}

class Episode {
  int id;
  int dtId;
  int seasonId;
  String name;
  String description;
  String type;
  String? link;
  String? media; // Change made here
  int status;
  String userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Episode({
    required this.id,
    required this.dtId,
    required this.seasonId,
    required this.name,
    required this.description,
    required this.type,
    this.link,
    this.media, // Change made here
    required this.status,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json["id"],
    dtId: json["dt_id"],
    seasonId: json["season_id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    link: json["link"],
    media: json["media"],
    status: json["status"],
    userType: json["user_type"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dt_id": dtId,
    "season_id": seasonId,
    "name": name,
    "description": description,
    "type": type,
    "link": link,
    "media": media,
    "status": status,
    "user_type": userType,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
