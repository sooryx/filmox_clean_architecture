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
    IndividualDTModel individualDTModel = IndividualDTModel.fromJson(response);

    return DtDashboardEntity(
      id: individualDTModel.data.id,
      uploadType: individualDTModel.data.uploadType,
      categoryId: individualDTModel.data.categoryId,
      title: individualDTModel.data.title,
      poster: individualDTModel.data.poster,
      year: individualDTModel.data.year,
      // Fixed to use year instead of categoryId
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
      cast: individualDTModel.data.cast?.map(
          (cast) => DashboardCastEntity(name: cast.name, role: cast.role, image: cast.image)).toList(),
      crew: individualDTModel.data.crew?.map(
          (crew) => DashboardCastEntity(name: crew.name, role: crew.role, image: crew.image)).toList(),
      // Handle nulls for seasons, and ensure non-null values
      seasons: individualDTModel.data.seasons.map((season) {
        return DashboardSeasonEntity(
          id: season.id,
          dtId: season.dtId,
          name: season.name,
          // Provide default value if null
          trailerType: season.trailerType,
          year: season.year,
          // Provide default value if null
          status: season.status,
          // Provide default value if null
          userType: season.userType,
          isPublish: season.isPublish,
          // Default to false if null
          trailerMediaFile: season.trailerMediaFile ?? '',
          trailerMediaLink: season.trailerMediaLink ?? '',
          episodes: season.episodes?.map((episode) {
                return DashboardEpisodeEntity(
                  name: episode.name,
                  // Provide default value if null
                  media: episode.media ?? '',
                  type: episode.type,
                  status: episode.status,
                  // Provide default value if null
                  description: episode.description,
                  dtId: episode.dtId,
                  // Provide default value if null
                  id: episode.id,
                  // Provide default value if null
                  seasonId: episode.seasonId,
                  // Provide default value if null
                  link: episode.link ?? '', // Provide default value if null
                );
              }).toList() ??
              [], // Ensure episodes is non-null, default to empty list
        );
      }).toList(), // Ensure seasons is non-null, default to empty list
    );
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
