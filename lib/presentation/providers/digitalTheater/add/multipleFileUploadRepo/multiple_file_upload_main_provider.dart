// ignore_for_file: unused_import

import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/multiplefileupload/multiple_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/singlefileupload/single_file_upload_main_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';

class MultipleFileUploadMainProvider with ChangeNotifier {
  final MultipleFileUploadMainRepo _multipleFileUploadMainRepo =
  MultipleFileUploadMainRepo();

  DTInfoFormEntity? _dtInfoFormEntity;

  DTInfoFormEntity? get dtInfoFormEntity => _dtInfoFormEntity;

  DefaultPageStatus _status = DefaultPageStatus.initial;

  DefaultPageStatus get status => _status;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _status = DefaultPageStatus.loading;
    notifyListeners();
    try {
      _dtInfoFormEntity = await _multipleFileUploadMainRepo.fetchcategories();
    } catch (e) {
      _errorMessage = e.toString();
      _status = DefaultPageStatus.failed;
      notifyListeners();
    } finally {
      _status = DefaultPageStatus.success;
      notifyListeners();
    }
  }
}
