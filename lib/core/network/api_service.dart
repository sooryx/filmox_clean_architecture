import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:filmox_clean_architecture/core/errors/app_exceptions.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:myself/myself.dart';
import 'package:path/path.dart' as path;

enum DefaultPageStatus { initial, loading, success, failed }

class ApiService {
  static const String baseUrl = UrlStrings.baseUrl;

  SharedPreferencesManager sharedPreferencesManager =
  SharedPreferencesManager();

  Future<dynamic> get(String endpoint) async {
    String? bearerToken = await SharedPreferencesManager().getAccessToken();

    if (await _isConnected()) {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      );
      print(
          "Response Status Code for GET Method ${baseUrl + endpoint} :${response.statusCode}");
      return _processResponse(response);
    } else {
      throw NoInternetException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    String? bearerToken = await SharedPreferencesManager().getAccessToken();
    if (await _isConnected()) {
      http.Response response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode(body),
      );
      _printValues(body: body, endpoint: endpoint, response: response, token: bearerToken ?? "No token");
      return _processResponse(response);
    } else {
      throw NoInternetException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<void> sendMultipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    String? bearerToken = await SharedPreferencesManager().getAccessToken();

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'))
      ..headers['Authorization'] = 'Bearer $bearerToken';

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    for (var entry in files.entries) {
      final file = entry.value;
      if (await file.exists()) {
        request.files.add(
          http.MultipartFile(
            entry.key,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: path.basename(file.path),
          ),
        );
      } else {
        print("Error: File ${file.path} does not exist.");
      }
    }

    final response = await request.send();
    String responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Upload successful!');
    } else {

      MySelfColor().printError(text: '''
      Upload failed with status code: ${response.statusCode}
      Upload failed with response body: ${responseBody}
      '''  );
    }
  }



  void _printValues({
    required String token,
    required String endpoint,
    required http.Response response,
    required Map<String, dynamic> body,
  }) {
   if(response.statusCode == 200 || response.statusCode ==201) {
    MySelfColor().printSuccess(text: '''
==========================================
                  POST METHOD 
Token: $token
Endpoint: ${baseUrl + endpoint}
Response Status Code: ${response.statusCode}
Body Sending: $body
Response Body: ${response.body}

==========================================
''');
   }else{
     MySelfColor().printError(text: '''
==========================================
                  POST METHOD 
Token: $token
Endpoint: ${baseUrl + endpoint}
Response Status Code: ${response.statusCode}
Body Sending: $body
Response Body: ${response.body}

==========================================
''');
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
      case 422:
        throw ServerException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }
}
