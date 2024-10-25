import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/auth/auth_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/userType/user_type_entity.dart';
import 'package:flutter/material.dart';

class AuthProvdier extends ChangeNotifier {
  AuthRepository authRepository = AuthRepository();

  TextEditingController phoneNumberController = TextEditingController();

  DefaultPageStatus _status = DefaultPageStatus.initial;

  DefaultPageStatus get status => _status;

  List<UserTypeEntity> _userTypeEntity = [];

  List<UserTypeEntity> get userTypeEntity => _userTypeEntity;

  Future<void> fetchUserTypes() async {

    _status = DefaultPageStatus.loading;
    notifyListeners();
    try {
      _userTypeEntity = await authRepository.fetchUserTypes();
      _status = DefaultPageStatus.success;
    } catch (e) {
      _status = DefaultPageStatus.failed;
      print("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  String _selectedUserType = "fan";

  set selectedUserType(String value) {
    _selectedUserType = value;
  }

  Future<void> userSignin() async {
    _status = DefaultPageStatus.loading;
    notifyListeners();

    try {
      final response = await authRepository.signin(
          phoneNumber: phoneNumberController.text, otp: '5555');
      _status = DefaultPageStatus.success;
      return response;
    } catch (e) {
      _status = DefaultPageStatus.failed;
      print("Error: $e");
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }
}
