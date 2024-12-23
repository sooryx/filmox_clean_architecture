
class DtDashboardEntity {
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
  List<DashboardCastEntity>? cast;
  List<DashboardCastEntity>? crew;
  List<DashboardSeasonEntity> seasons;

  DtDashboardEntity({
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


}

class DashboardCastEntity {
  int? id;
  int? dtId;
  String name;
  String role;
  String image;
  String? userType;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  DashboardCastEntity({
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


}

class DashboardSeasonEntity {
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
  List<DashboardEpisodeEntity>? episodes;

  DashboardSeasonEntity({
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

    this.episodes,
  });


}

class DashboardEpisodeEntity {
  int id;
  int dtId;
  int seasonId;
  String name;
  String description;
  String type;
  String? link;
  String? media; // Change made here
  int status;

  DashboardEpisodeEntity({
    required this.id,
    required this.dtId,
    required this.seasonId,
    required this.name,
    required this.description,
    required this.type,
    this.link,
    this.media, // Change made here
    required this.status,

  });


}
