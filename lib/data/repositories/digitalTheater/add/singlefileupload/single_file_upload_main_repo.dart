import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/data/models/digitalTheater/add/fetch_category.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';

class SingleFileUploadMainRepo {
  final ApiService _apiService = ApiService();
  final SharedPreferencesManager _sharedPreferencesManager =SharedPreferencesManager();
  
  
  /*Endpoint for each step */
  String getStepEndpoint = '/get_step_dt';
  String step1Endpoint = '/add_single_media_details';
  String step2Endpoint = '/add_single_media_trailer';
  String step3Endpoint = '/add_single_media_clip';
  String step4Endpoint = '/add_cast_single';
  String step5Endpoint = '/add_crew_single';

  /*To Fetch Step initially ,and fetch categorie,genre,language*/

  Future<DTInfoFormEntity> fetchCategories() async {
    String dtID = await _sharedPreferencesManager.getSingleDTID() ?? "";

    final response = await _apiService.post(getStepEndpoint, {'dt_id': dtID});
    FetchCategory dataModel = FetchCategory.fromJson(response);
    _sharedPreferencesManager.setSingleFileID(dataModel.data.dtID!=null?dataModel.data.dtID.toString() : '0');
    return DTInfoFormEntity(
      dtID: dataModel.data.dtID ?? 0,
      step: dataModel.data.step,
      categories: dataModel.data.categories.map((category) =>
          CategoryEntity(
            id: category.id,
            title: category.category,

          )).toList(),
      genres: dataModel.data.genres.map((genre) =>
          CategoryEntity(
            id: genre.id,
            title: genre.genre,
          )).toList(),
      languages: dataModel.data.languages.map((language) =>
          CategoryEntity(
            id: language.id,
            title: language.language,
          )).toList(),
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
      step1Endpoint,
      body,
    );
   String dtId = response['data']['id'].toString();
   _sharedPreferencesManager.setSingleFileID(dtId);

    return response;
  }

/*POST Step 2 API*/

  Future<void> step2API({
    required bool isFile,
    required File poster,
    File? trailerFile,
    String trailerLink = '',
  }) async {
    final String? digitalTheatreId = await SharedPreferencesManager().getSingleDTID();

    Map<String, String> textBody = {
      'dt_id': digitalTheatreId ?? '0',
    };

    // Add trailer link only if it’s not empty
    if (trailerLink.isNotEmpty) {
      textBody['trailer_type'] = 'url';
      textBody['trailer_media_link'] = trailerLink;
    }

    Map<String, File> fileBody = {'poster': poster};

    // Add trailer file only if it's available
    if (trailerFile != null) {
      fileBody['trailer_media_file'] = trailerFile;
    }

    if (isFile) {
      final response = await _apiService.sendMultipartRequest(
        endpoint: step2Endpoint,
        files: fileBody,
        fields: textBody,
      );
      return response;
    } else {
      final response = await _apiService.post(step2Endpoint, textBody);

      return response;
    }
  }

/*POST Step 3 API*/


  Future<void> step3API({
    required bool isFile,
    required File? singleMediaFile,
    required String singleMediaLink,
  }) async {
    final String? digitalTheatreId = await SharedPreferencesManager().getSingleDTID();

    Map<String, String> textBody = {
      'dt_id': digitalTheatreId ?? '0',
    };

    if (singleMediaLink.isNotEmpty) {
      textBody['trailer_type'] = 'url';
      textBody['trailer_media_link'] = singleMediaLink;
    }

    Map<String, File> fileBody = {};
    if (singleMediaFile != null) {
      fileBody['single_media_file'] = singleMediaFile;
    }

    if (isFile) {
      final response = await _apiService.sendMultipartRequest(
        endpoint: step3Endpoint,
        files: fileBody,
        fields: textBody,
      );

      return response;
    } else {
      final response = await _apiService.post(step3Endpoint, textBody);
      return response;
    }
  }


  /*POST Step 4 API*/
  Future<void> step4API({
    required String name,
    required String role,
    required File image,
  }) async {
    String? digiID = await SharedPreferencesManager().getSingleDTID();

    Map<String, String> textBody = {
      'dt_id': digiID ?? '0',
      'name': name,
      'role': role,

    };
    Map<String, File> fileBody = {
      'image': image
    };
    final response = await _apiService.sendMultipartRequest(
        endpoint: step4Endpoint, fields: textBody, files: fileBody);
    return response;
  }

  /*POST Step 5 API*/
  Future<void> ste5API({
    required String name,
    required String role,
    required File image,
  }) async {
    String? digiID = await SharedPreferencesManager().getSingleDTID();

    Map<String, String> textBody = {
      'dt_id': digiID ?? '0',
      'name': name,
      'role': role,

    };
    Map<String, File> fileBody = {
      'image': image
    };
    final response = await _apiService.sendMultipartRequest(
        endpoint: step5Endpoint, fields: textBody, files: fileBody);
    return response;
  }


}



