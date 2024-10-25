import 'dart:convert';

DigitalTheaterMainPageModel digitalTheaterMainPageModelFromJson(String str) => DigitalTheaterMainPageModel.fromJson(json.decode(str));

String digitalTheaterMainPageModelToJson(DigitalTheaterMainPageModel data) => json.encode(data.toJson());

class DigitalTheaterMainPageModel {
  bool status;
  String message;
  Data data;

  DigitalTheaterMainPageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DigitalTheaterMainPageModel.fromJson(Map<String, dynamic> json) => DigitalTheaterMainPageModel(
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
  List<BannerData> banners;
  List<All> all;
  List<Category> categories;
  List<dynamic> errors;

  Data({
    required this.banners,
    required this.all,
    required this.categories,
    required this.errors,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    banners: List<BannerData>.from(json["banners"].map((x) => BannerData.fromJson(x))),
    all: List<All>.from(json["all"].map((x) => All.fromJson(x))),
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    errors: List<dynamic>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
    "all": List<dynamic>.from(all.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "errors": List<dynamic>.from(errors.map((x) => x)),
  };
}

class All {
  int id;
  String sectionName;
  String digitalTheatre;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<DigitalTheatre> digitalTheatres;

  All({
    required this.id,
    required this.sectionName,
    required this.digitalTheatre,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.digitalTheatres,
  });

  factory All.fromJson(Map<String, dynamic> json) => All(
    id: json["id"],
    sectionName: json["section_name"],
    digitalTheatre: json["digital_theatre"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    digitalTheatres: List<DigitalTheatre>.from(json["digital_theatres"].map((x) => DigitalTheatre.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_name": sectionName,
    "digital_theatre": digitalTheatre,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "digital_theatres": List<dynamic>.from(digitalTheatres.map((x) => x.toJson())),
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
  List<DigitalTheatre>? digitalTheatreMain;

  Category({
    required this.id,
    this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.genre,
    this.language,
    this.digitalTheatreMain,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    category: json["category"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    genre: json["genre"],
    language: json["language"],
    digitalTheatreMain: json["digital_theatre_main"] == null ? [] : List<DigitalTheatre>.from(json["digital_theatre_main"]!.map((x) => DigitalTheatre.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "genre": genre,
    "language": language,
    "digital_theatre_main": digitalTheatreMain == null ? [] : List<dynamic>.from(digitalTheatreMain!.map((x) => x.toJson())),
  };
}

class DigitalTheatre {
  int id;
  int uploadType;
  int categoryId;
  String title;
  String poster;
  int year;
  String certificate;
  dynamic rating;
  int? hours;
  int? minutes;
  int genreId;
  int languageId;
  String storyLine;
  String? trailerType;
  String? trailerMediaFile;
  String? trailerMediaLink;
  dynamic castId;
  dynamic crewId;
  String? singleMediaType;
  String? singleMediaFile;
  String? singleMediaLink;
  dynamic multipleMediaId;
  int status;
  String userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Cast> cast;
  List<Cast> crew;
  List<Season>? seasons;

  DigitalTheatre({
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
    required this.trailerType,
    required this.trailerMediaFile,
    required this.trailerMediaLink,
    required this.castId,
    required this.crewId,
    required this.singleMediaType,
    required this.singleMediaFile,
    required this.singleMediaLink,
    required this.multipleMediaId,
    required this.status,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.cast,
    required this.crew,
    this.seasons,
  });

  factory DigitalTheatre.fromJson(Map<String, dynamic> json) => DigitalTheatre(
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
    castId: json["cast_id"],
    crewId: json["crew_id"],
    singleMediaType: json["single_media_type"],
    singleMediaFile: json["single_media_file"],
    singleMediaLink: json["single_media_link"],
    multipleMediaId: json["multiple_media_id"],
    status: json["status"],
    userType: json["user_type"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
    crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    seasons: json["seasons"] == null ? null : List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
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
    "cast_id": castId,
    "crew_id": crewId,
    "single_media_type": singleMediaType,
    "single_media_file": singleMediaFile,
    "single_media_link": singleMediaLink,
    "multiple_media_id": multipleMediaId,
    "status": status,
    "user_type": userType,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
    "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
    "seasons": seasons == null ? null : List<dynamic>.from(seasons!.map((x) => x.toJson())),
  };
}

class Cast {
  int id;
  int dtId;
  String name;
  String role;
  String image;
  String userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Cast({
    required this.id,
    required this.dtId,
    required this.name,
    required this.role,
    required this.image,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
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
  int isPublish;
  int status;
  String userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Episode> episodes;

  Season({
    required this.id,
    required this.dtId,
    required this.name,
    required this.trailerType,
    this.trailerMediaFile,
    required this.trailerMediaLink,
    required this.year,
    required this.isPublish,
    required this.status,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    id: json["id"],
    dtId: json["dt_id"],
    name: json["name"],
    trailerType: json["trailer_type"],
    trailerMediaFile: json["trailer_media_file"],
    trailerMediaLink: json["trailer_media_link"],
    year: json["year"],
    isPublish: json["is_publish"],
    status: json["status"],
    userType: json["user_type"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    episodes: List<Episode>.from(json["episodes"].map((x) => Episode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dt_id": dtId,
    "name": name,
    "trailer_type": trailerType,
    "trailer_media_file": trailerMediaFile,
    "trailer_media_link": trailerMediaLink,
    "year": year,
    "is_publish": isPublish,
    "status": status,
    "user_type": userType,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
  };
}

class Episode {
  int id;
  int dtId;
  int seasonId;
  String? name;
  String? description;
  String? type;
  String? link;
  String? media;
  int status;
  String? userType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Episode({
    required this.id,
    required this.dtId,
    required this.seasonId,
    this.name,
    this.description,
    this.type,
    this.link,
    this.media,
    required this.status,
    this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json["id"],
    dtId: json["dt_id"],
    seasonId: json["season_id"],
    name: json["name"] as String?,
    description: json["description"] as String?,
    type: json["type"] as String?,
    link: json["link"] as String?,
    media: json["media"] as String?,
    status: json["status"],
    userType: json["user_type"] as String?,
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


enum Certificate { AA, U }

final certificateValues = EnumValues({
  "AA": Certificate.AA,
  "U": Certificate.U
});

enum Type { VIDEO }

final typeValues = EnumValues({
  "video": Type.VIDEO
});

enum UserType { USER }

final userTypeValues = EnumValues({
  "user": UserType.USER
});

class BannerData {
  int id;
  String title;
  String banner;
  String type;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  BannerData({
    required this.id,
    required this.title,
    required this.banner,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    id: json["id"],
    title: json["title"],
    banner: json["banner"],
    type: json["type"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "banner": banner,
    "type": type,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}