import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/profile/profile_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/profile/profile_entity.dart';
import 'package:flutter/cupertino.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo _profileRepo = ProfileRepo();

  DefaultPageStatus get status => _status;
  DefaultPageStatus _status = DefaultPageStatus.initial;

  ProfileEntity? _profileEntity;

  ProfileEntity? get profileEntity => _profileEntity;

  Future<void> fetchProfileData() async {
    _status = DefaultPageStatus.loading;
    try {
      final response = await _profileRepo.fetchProfileData();
      _profileEntity = response;
    } catch (e) {
      _status = DefaultPageStatus.failed;
      rethrow;
    } finally {
      _status = DefaultPageStatus.success;
    }
  }
}
