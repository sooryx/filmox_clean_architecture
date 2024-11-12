import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/data/models/digitalTheater/add/fetch_category.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';

class MultipleFileUploadMainRepo {
  final ApiService _apiService = ApiService();
  SharedPreferencesManager _sharedPreferencesManager =SharedPreferencesManager();
  /*To Fetch Step initially ,and fetch categorie,genre,language*/

  Future<DTInfoFormEntity> fetchcategories() async {
    String dtID = await _sharedPreferencesManager.getMultipleDTID() ?? "";

    final response = await _apiService.post('/get_step_dt', {'dt_id': dtID});
    FetchCategory dataModel = FetchCategory.fromJson(response);
    _sharedPreferencesManager.setMultipleFileID(dataModel.data.dtID !=null ? dataModel.data.dtID.toString() : '0');
    return DTInfoFormEntity(
      dtID: dataModel.data.dtID ??0,
      step: dataModel.data.step,
      categories: dataModel.data.categories
          .map((categories) =>
          CategoryEntity(
            id: categories.id,
            title: categories.category,
          ))
          .toList(),
      genres: dataModel.data.genres
          .map((genre) =>
          CategoryEntity(
            id: genre.id,
            title: genre.genre,
          ))
          .toList(),
      languages: dataModel.data.languages
          .map((lannguage) =>
          CategoryEntity(
            id: lannguage.id,
            title: lannguage.language,
          ))
          .toList(),
    );
  }

  /*POST Step 1 API*/

  Future<void> step1API({
    required category,
    required String title,
    required storyLine,
    required String year,
    required String certificate,
    required String genre,
    required String language,
    required int hour,
    required int minute,
  }) async {
    final Map<String, dynamic> body = {
      'category': category,
      'title': title,
      'year': year,
      'certificate': certificate,
      'hours': hour,
      'minutes': minute,
      'genre': genre,
      'language': language,
      'story_line': storyLine,
    };
    final response = await _apiService.post(
      '/add_multi_media_details',
      body,
    );
    String _dtId = response['data']['id'].toString();
    _sharedPreferencesManager.setMultipleFileID(_dtId);
    return response;
  }

/*POST Step 2 API*/

  Future<void> step2API({
    required bool isFile,
    required File poster,
    required File? trailerFile,
    required String trailerLink,
  }) async {
    final String? digitalTheatreId =
    await SharedPreferencesManager().getMultipleDTID();
    Map<String, String> textBody = {
      'dt_id': digitalTheatreId ?? '0',
      'trailer_type': 'url',
      'trailer_media_link': trailerLink
    };
    Map<String, File> fileBody = {
      'poster': poster,
      'trailer_media_file': trailerFile!,
    };
    if (isFile) {
      final response = await _apiService.sendMultipartRequest(
        endpoint: '/add_single_media_trailer',
        files: fileBody,
        fields: textBody,
      );

      return response;
    } else {
      final response =
      await _apiService.post('/add_multi_media_trailer', textBody);
      return response;
    }
  }

/*POST Step 3 API*/


  Future<void> step3API({
    required bool isFile,
    required File? singleMediaFile,
    required String? singleMediaLink,
  }) async {
    final String? digitalTheatreId =
    await SharedPreferencesManager().getMultipleDTID();

    print("Trailer Link :$singleMediaLink");

    Map<String, String> textBody = {
      'dt_id': digitalTheatreId ?? '0',
      'trailer_media_link': singleMediaLink ?? ''
    };

    Map<String, File> fileBody = {};
    if(singleMediaFile != null){
      fileBody[ 'trailer_media_file']= singleMediaFile;
    }
    if (isFile) {
      final response = await _apiService.sendMultipartRequest(
        endpoint: '/add_dt_season',
        files: fileBody,
        fields: textBody,
      );
      return response;
    } else {
      final response = await _apiService.post('/add_dt_season', textBody);

      return response;
    }
  }

  /*POST Step 4 API*/
  Future<void> step4API({
    required String name,
    required String role,
    required File image,
  }) async {
    String? digiID = await SharedPreferencesManager().getMultipleDTID();

    Map<String, String> textBody = {
      'dt_id': digiID ?? '0',
      'name': name,
      'role': role,

    };
    Map<String, File> fileBody = {
      'image': image
    };
    final response = await _apiService.sendMultipartRequest(
        endpoint: '/add_cast_single', fields: textBody, files: fileBody);
    return response;
  }

  /*POST Step 5 API*/
  Future<void> ste5API({
    required String name,
    required String role,
    required File image,
  }) async {
    String? digiID = await SharedPreferencesManager().getMultipleDTID();

    Map<String, String> textBody = {
      'dt_id': digiID ?? '0',
      'name': name,
      'role': role,

    };
    Map<String, File> fileBody = {
      'image': image
    };
    final response = await _apiService.sendMultipartRequest(
        endpoint: '/add_crew_single', fields: textBody, files: fileBody);
    return response;
  }


}



