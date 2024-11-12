import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/digitalTheater/dt_main/digital_theater_main_model.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dt_main/digital_theater_main_entity.dart';

class DigitaltheaterRepo {
  final ApiService _apiService = ApiService();

  Future<DigitalTheaterMainPageModel> fetchDTMainData() async {
    try {
      final response = await _apiService.post('/fetch_dt_main_data', {});
      final dataModel = DigitalTheaterMainPageModel.fromJson(response);
      return dataModel; // Returning the data model for further use
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<BannersEntity>> fetchBanner(
      DigitalTheaterMainPageModel dataModel) async {
    return dataModel.data.banners
        .map((i) => BannersEntity(
              id: i.id,
              name: i.title,
              banner: i.banner,
              type: i.type,
              isActive: i.isActive == 1,
            ))
        .toList();
  }

  Future<List<AllDTEntity>> fetchAllDt(
      DigitalTheaterMainPageModel dataModel) async {
    return dataModel.data.all
        .map((i) => AllDTEntity(
            sectionName: i.sectionName,
            digitalTheaterEntity: i.digitalTheatres
                .map((theatres) => DigitalTheaterEntity(
                      id: theatres.id,
                      uploadType: theatres.uploadType,
                      isTrailerYoutube: theatres.trailerType == 'url',
                      isSingleMediaYoutube: theatres.singleMediaType == 'url',
                      name: theatres.title,
                      poster: theatres.poster,
                      storyLine: theatres.storyLine,
                      trailerLink: (theatres.trailerType == 'url'
                              ? theatres.trailerMediaLink
                              : theatres.trailerMediaFile) ??
                          '',
                      crew: theatres.crew
                          .map((cast) => CastEntity(
                              name: cast.name,
                              image: cast.image,
                              role: cast.role))
                          .toList(),
                      cast: theatres.cast
                          .map((cast) => CastEntity(
                              name: cast.name,
                              image: cast.image,
                              role: cast.role))
                          .toList(),
                      seasons: (theatres.seasons ?? [])
                          .map((seasons) => SeasonEntity(
                              name: seasons.name,
                              isYoutubeurl: seasons.trailerType == 'url',
                              trailer: (seasons.trailerType == 'url'
                                      ? seasons.trailerMediaLink
                                      : seasons.trailerMediaFile) ??
                                  "",
                              episodes: seasons.episodes
                                  .map((episodes) => EpisodeEntity(
                                        name: episodes.name ?? "",
                                        descritption:
                                            episodes.description ?? "",
                                        isYoutubeUrl: episodes.type == 'link',
                                        mediaLink: (episodes.type == 'link'
                                                ? episodes.link
                                                : episodes.media) ??
                                            '',
                                      ))
                                  .toList()))
                          .toList(),
                    ))
                .toList()))
        .toList();
  }

  Future<List<TabsEntity>> fetchtabEntity(
      DigitalTheaterMainPageModel dataModel) async {
    List<TabsEntity> _tabs = [];
    for (var categories in dataModel.data.categories) {
      _tabs.add(TabsEntity(
        tabName: categories.category ?? "",
        digitalTheaterEntity: categories.digitalTheatreMain
                ?.map((theatre) => DigitalTheaterEntity(
                      id: theatre.id,
                      uploadType: theatre.uploadType,
                      name: theatre.title,
                      poster: theatre.poster,
                      storyLine: theatre.storyLine,
                      isTrailerYoutube: theatre.trailerType == 'url',
                      isSingleMediaYoutube: theatre.singleMediaType == 'url',
                      trailerLink: (theatre.trailerType == 'url'
                              ? theatre.trailerMediaLink
                              : theatre.trailerMediaFile) ??
                          '',
                      cast: theatre.cast
                          .map((cast) => CastEntity(
                              name: cast.name,
                              image: cast.image,
                              role: cast.role))
                          .toList(),
                      crew: theatre.crew
                          .map((crew) => CastEntity(
                              name: crew.name,
                              image: crew.image,
                              role: crew.role))
                          .toList(),
                      seasons: (theatre.seasons ?? [])
                          .map((seasons) => SeasonEntity(
                              name: seasons.name,
                              isYoutubeurl: seasons.trailerType == 'url',
                              trailer: (seasons.trailerType == 'url'
                                      ? seasons.trailerMediaLink
                                      : seasons.trailerMediaFile) ??
                                  "",
                              episodes: seasons.episodes
                                  .map((episodes) => EpisodeEntity(
                                        name: episodes.name ?? "",
                                        descritption:
                                            episodes.description ?? "",
                                        isYoutubeUrl: episodes.type == 'link',
                                        mediaLink: (episodes.type == 'link'
                                                ? episodes.link
                                                : episodes.media) ??
                                            '',
                                      ))
                                  .toList()))
                          .toList(),
                    ))
                .toList() ??
            [],
      ));
    }

    return _tabs;
  }
}
