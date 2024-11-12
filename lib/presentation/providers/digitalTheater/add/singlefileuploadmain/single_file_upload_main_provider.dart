import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/singlefileupload/single_file_upload_main_repo.dart';
import 'package:filmox_clean_architecture/domain/entity/digitalTheater/add/trailer_booster.dart';
import 'package:flutter/cupertino.dart';

class SingleFileUploadMainProvider with ChangeNotifier {
  final SingleFileUploadMainRepo _singleFileUploadMainRepo =
      SingleFileUploadMainRepo();

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
      _dtInfoFormEntity = await _singleFileUploadMainRepo.fetchCategories();
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
