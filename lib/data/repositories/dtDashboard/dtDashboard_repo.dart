import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/models/digitalTheater/add/fetch_category.dart';
import 'package:filmox_clean_architecture/data/models/digitalTheater/dashboard/individual_dt_model.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/dashboard/dt_dashboard_entity.dart';

class DtdashboardRepo {
  final ApiService _apiService = ApiService();
  String fetchDTDetails = '/fetch_dt_seasons_by_dtid';
  String getCategories = '/get_step_dt';

  Future<DtDashboardEntity> fetchdtDetails(
      {required String digitalTheaterID}) async {
    final response =
        await _apiService.post(fetchDTDetails, {'dt_id': digitalTheaterID});
    IndividualDTModel individualDTModel = response;
    return DtDashboardEntity(
        id: individualDTModel.data.id,
        uploadType: individualDTModel.data.uploadType,
        categoryId: individualDTModel.data.categoryId,
        title: individualDTModel.data.title,
        poster: individualDTModel.data.poster,
        year: individualDTModel.data.categoryId,
        certificate: individualDTModel.data.certificate,
        rating: individualDTModel.data.rating,
        hours: individualDTModel.data.hours,
        minutes: individualDTModel.data.minutes,
        genreId: individualDTModel.data.genreId,
        languageId: individualDTModel.data.languageId,
        storyLine: individualDTModel.data.storyLine,
        status: individualDTModel.data.status,
        userType: individualDTModel.data.userType,
        userId: individualDTModel.data.userId,
        step: individualDTModel.data.step,
        createdAt: individualDTModel.data.createdAt,
        updatedAt: individualDTModel.data.updatedAt,
        seasons: individualDTModel.data.seasons
            .map((season) => DashboardSeasonEntity(
                id: season.id,
                dtId: season.dtId,
                name: season.name,
                trailerType: season.trailerType,
                year: season.year,
                status: season.status,
                userType: season.userType,
                isPublish: season.isPublish,
                trailerMediaFile: season.trailerMediaFile,
                trailerMediaLink: season.trailerMediaLink,
                episodes: season.episodes
                    ?.map((episode) => DashboardEpisodeEntity(
                        name: episode.name,
                        media: episode.media,
                        type: episode.type,
                        status: episode.status,
                        description: episode.description,
                        dtId: episode.dtId,
                        id: episode.id,
                        seasonId: episode.seasonId,
                        link: episode.link))
                    .toList()))
            .toList());
  }

  Future<DTInfoFormEntity> fetchCategories() async {
    final response = await _apiService.post(getCategories, {});
    FetchCategory dataModel = FetchCategory.fromJson(response);
    return DTInfoFormEntity(
      dtID: dataModel.data.dtID ?? 0,
      step: dataModel.data.step,
      categories: dataModel.data.categories
          .map((category) => CategoryEntity(
                id: category.id,
                title: category.category,
              ))
          .toList(),
      genres: dataModel.data.genres
          .map((genre) => CategoryEntity(
                id: genre.id,
                title: genre.genre,
              ))
          .toList(),
      languages: dataModel.data.languages
          .map((language) => CategoryEntity(
                id: language.id,
                title: language.language,
              ))
          .toList(),
    );
  }
}
