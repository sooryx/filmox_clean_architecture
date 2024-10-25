

class ContestEntity {
  int contestID;
  String name;
  String categoryName;
  String poster;
  DateTime startDate;
  DateTime voteDate;
  DateTime endDate;
  String contestDesc;
  String megaAuditionDesc;
  int? isPublished;
  List<BannerEntity>? banners;
  List<GuestEntity>? guests;
  List<UserMediaEntity>? userMedia;

  ContestEntity({
    required this.contestID,
    required this.name,
    required this.categoryName,
    required this.poster,
    required this.startDate,
    required this.voteDate,
    required this.endDate,
    required this.contestDesc,
    required this.megaAuditionDesc,
    this.isPublished,
    this.banners,
    this.guests,
    this.userMedia,
  });
}

class BannerEntity {
  int? id;
  int? bpId;
  String? banner;
  int? type;
  int? status;

  BannerEntity({
    this.id,
    this.bpId,
    this.banner,
    this.type,
    this.status,
  });
}

class GuestEntity {
  int? id;
  String? name;
  String? image;

  GuestEntity({
    this.id,
    this.name,
    this.image,
  });
}

class UserMediaEntity {
  int id;
  String media;
  int mediaType;
  String thumbnail;
  int status;

  UserMediaEntity({
    required this.id,
    required this.media,
    required this.mediaType,
    required this.thumbnail,
    required this.status,
  });
}
