import 'dart:convert';


import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/data/models/contest/rc_result_main_model/rc_result_main_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegularContestMainResultScreenProvider with ChangeNotifier{
  RcMainResultsModel? _rcMainResultsModel;
  RcMainResultsModel? get rcMainResultsModel => _rcMainResultsModel;

  bool _isResultsLoading = false;
  bool get isResultsLoading => _isResultsLoading;


  Future<void> fetchMainScreenResults(int contestId) async {
    _isResultsLoading = true;
    notifyListeners();
    final token = await SharedPreferencesManager().getAccessToken();

    final url = Uri.parse('${UrlStrings.baseUrl}/api/final_contestants');
    final Map<String, dynamic> data = {
      'contest_id': contestId.toString(),
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
      print("Response Data:${response.body}");
      if (response.statusCode == 201 ||  response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _rcMainResultsModel = RcMainResultsModel.fromJson(responseData);

        print('Data Length: ${_rcMainResultsModel?.data?.length}');
      } else {
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }finally{
      _isResultsLoading = false;
      notifyListeners();
    }
  }
}