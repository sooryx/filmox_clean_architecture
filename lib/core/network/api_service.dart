import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:filmox_clean_architecture/core/errors/app_exceptions.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:http/http.dart' as http;

enum DefaultPageStatus { initial, loading, success, failed }

class ApiService {
  static const String baseUrl = UrlStrings.baseUrl;
  SharedPreferencesManager sharedPreferencesManager =
      SharedPreferencesManager();

  Future<dynamic> get(String endpoint) async {
    String? token = await SharedPreferencesManager().getAccessToken();

    if (await _isConnected()) {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      print(
          "Response Status Code for ${baseUrl + endpoint} :${response.statusCode}");
      return _processResponse(response);
    } else {
      throw NoInternetException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    String? token = await SharedPreferencesManager().getAccessToken();
    print(token);
    if (await _isConnected()) {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: json.encode(body),
      );
      print(
          "Response Status Code for ${baseUrl + endpoint} :${response.statusCode}");
      print("Body Sending:${body}");
      return _processResponse(response);
    } else {
      throw NoInternetException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw PageNotFoundException(response.body.toString());
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }
}
