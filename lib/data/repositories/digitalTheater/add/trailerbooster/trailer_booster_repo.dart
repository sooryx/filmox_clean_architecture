// ignore_for_file: unused_import

import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';

class TrailerBoosterRepo {
  final ApiService _apiService = ApiService();

  // Future<DTInfoFormEntity>fetchCategories()async{
  //   final response = await _apiService.post('/get_step_dt',{});
  //   return response;
  // }

  Future<void> saveTrailerBooster({
    required String title,
    required File poster,
    required File media,
  }) async {
    final response = await _apiService
        .sendMultipartRequest(endpoint: '/add_trailer_booster', fields: {
      'title': title
    }, files: {
      'poster': poster,
      'media': media,
    });
    return response;
  }
}
