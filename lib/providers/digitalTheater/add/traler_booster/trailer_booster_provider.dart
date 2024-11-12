import 'dart:io';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/trailerbooster/trailer_booster_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';
import 'package:flutter/cupertino.dart';

class TrailerBoosterProvider with ChangeNotifier {
  final TrailerBoosterRepo _trailerBoosterRepo = TrailerBoosterRepo();

  String _title = '';

  String get title => _title;

  set settitle(String value) {
    _title = value;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  DefaultPageStatus _staus = DefaultPageStatus.initial;

  DefaultPageStatus get staus => _staus;

  File? _videoFile;

  File? get videoFile => _videoFile;

  set setvideoFile(File value) {
    _videoFile = value;
    notifyListeners();
  }

  File? _posterFile;

  File? get posterFile => _posterFile;

  set setposterFile(File value) {
    _posterFile = value;
    notifyListeners();
  }

  DTInfoFormEntity? _dtInfoFormEntity;

  DTInfoFormEntity? get dtInfoFormEntity => _dtInfoFormEntity;

  Future<void> saveTrailerBooster() async {
    _staus = DefaultPageStatus.loading;

    bool isValid = ValidatingTheFields();

    if (!isValid) {
      _staus = DefaultPageStatus.failed;
      notifyListeners();

      print('Validation failed. Please check the input fields.');
      throw Exception('Validation failed. Please check the input fields.');
    }
    try {
      final response = await _trailerBoosterRepo.saveTrailerBooster(
          title: _title, poster: _posterFile!, media: _videoFile!);

      return response;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _staus = DefaultPageStatus.success;
      notifyListeners();
    }
  }

  bool ValidatingTheFields() {
    if (_title == '' || _videoFile == null || _posterFile == null) {
      return false;
    }
    return true;
  }
}
