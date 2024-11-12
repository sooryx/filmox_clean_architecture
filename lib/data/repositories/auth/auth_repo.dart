import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/core/utils/local_storage.dart';
import 'package:filmox_clean_architecture/data/models/usertype/select_user_type_model.dart';
import 'package:filmox_clean_architecture/domain/entity/userType/user_type_entity.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  SharedPreferencesManager sharedPreferencesManager =
  SharedPreferencesManager();


  Future<UserInfoEntity> signin({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _apiService.post('/userLogin', {
      'phone': phoneNumber,
      'otp': otp,
    });

    if (response.containsKey('access_token')) {
      String accessToken = response['access_token'];
      await sharedPreferencesManager.setAccessToken(accessToken);

      var user = response['user'];
      var profile = response['profile'];

      return
        UserInfoEntity(
          userName: user['username'],
          userType: user['type'],
          userImage: profile['profile_photo'],
        );

    } else {
      // Handle the case where the access token is not present
      throw Exception('Failed to sign in');
    }
  }


  Future<List<UserTypeEntity>> fetchUserTypes() async {
    final response = await _apiService.get('/userTypeScreen');
    final dataModel = UserTypeModel.fromJson(response);
    return dataModel.data.map((i) =>
        UserTypeEntity(image: i.media, description: i.description)).toList();
  }

  Future<void> signup({
    required String name,
    required String phoneNumber,
    required String email,
    required String state,
    required String industry,
    required String proffession,
    required String selectedUserType,
  }) async {
    final response = await _apiService.post('/newUserRegister', {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'state': state,
      'industry': industry,
      'profession': proffession,
      'otp': '5555',
      'type': selectedUserType,
    });
    return response;
  }
}
