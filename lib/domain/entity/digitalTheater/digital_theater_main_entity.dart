class BannersEntity {
  int id;
  String name;
  String banner;
  String type;
  bool isActive;

  BannersEntity(
      {required this.id,
      required this.name,
      required this.banner,
      required this.type,
      required this.isActive});
}

class AllDTEntity {
  String sectionName;
  List<DigitalTheaterEntity> digitalTheaterEntity;

  AllDTEntity({required this.sectionName, required this.digitalTheaterEntity});
}

class TabsEntity {
  String tabName;
  List<DigitalTheaterEntity> digitalTheaterEntity;

  TabsEntity({required this.tabName, required this.digitalTheaterEntity});
}

class DigitalTheaterEntity {
  int id;
  int uploadType;
  String name;
  String poster;
  String storyLine;
  bool isTrailerYoutube;
  bool isSingleMediaYoutube;
  String trailerLink;
  List<CastEntity> cast;
  List<CastEntity> crew;
  List<SeasonEntity> seasons;

  DigitalTheaterEntity({
    required this.id,
    required this.uploadType,
    required this.name,
    required this.poster,
    required this.storyLine,
    required this.trailerLink,
    required this.isTrailerYoutube,
    required this.isSingleMediaYoutube,
    required this.cast,
    required this.crew,
    required this.seasons,
  });
}

class CastEntity {
  String name;
  String role;
  String image;

  CastEntity({required this.name, required this.role, required this.image});
}

class SeasonEntity {
  String name;
  bool isYoutubeurl;
  String trailer;
  List<EpisodeEntity> episodes;

  SeasonEntity({
    required this.name,
    required this.trailer,
    required this.isYoutubeurl,
    required this.episodes,
  });
}

class EpisodeEntity {
  String name;
  String mediaLink;
  String descritption;
  bool isYoutubeUrl;

  EpisodeEntity({
    required this.name,
    required this.mediaLink,
    required this.descritption,
    required this.isYoutubeUrl,
  });
}
