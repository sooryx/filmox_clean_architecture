

import 'package:filmox_clean_architecture/core/utils/urls.dart';

class ContestEntity {
  int contestID;
  int mediaType;
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
    required this.mediaType,
    required this.name,
    required this.categoryName,
    required String poster,
    required this.startDate,
    required this.voteDate,
    required this.endDate,
    required this.contestDesc,
    required this.megaAuditionDesc,
    this.isPublished,
    this.banners,
    this.guests,
    this.userMedia,
  }) : poster = '${UrlStrings.imageUrl}$poster'; // Prepend base URL to poster
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
    required String banner,
    this.type,
    this.status,
  }) : banner = UrlStrings.imageUrl + banner;
}

class GuestEntity {
  int? id;
  String? name;
  String? image;

  GuestEntity({
    this.id,
    this.name,
    required String image,
  }) : image = UrlStrings.imageUrl + image;
}

class UserMediaEntity {
  int id;
  String media;
  int mediaType;
  String thumbnail;
  int status;

  UserMediaEntity({
    required this.id,
    required String media,
    required this.mediaType,
    required this.thumbnail,
    required this.status,
  }): media = mediaType == 2 ?'${UrlStrings.imageUrl}$media' : '${UrlStrings.videoUrl}$media';
}


