import 'dart:io';

import 'package:filmox_clean_architecture/core/network/api_service.dart';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/multiplefileupload/multiple_file_upload_main_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultipleFileUploadStep3Provider extends ChangeNotifier {

  final MultipleFileUploadMainRepo _multipleFileUploadMainRepo =
      MultipleFileUploadMainRepo();

  DefaultPageStatus _pageStatus = DefaultPageStatus.initial;
  String _title = '';
  String _year = '';
  File? _trailerMediaFile;
  String _trailerMediaLink = '';

  DefaultPageStatus get pageStatus => _pageStatus;
  String get title => _title;
  String get year => _year;
  File? get trailerMediaFile => _trailerMediaFile;
  String get trailerMediaLink => _trailerMediaLink;

  set title(String value) {
    _title = value;
    notifyListeners();
  }
  set year(String value) {
    _year = value;
    notifyListeners();
  }
  set settrailerMediaFile(File? value) {
    _trailerMediaFile = value;
    notifyListeners();
  }
  set settrailerMediaLink(String value) {
    _trailerMediaLink = value;
    notifyListeners();
  }
  final List<Season> _seasonList = [];
  List<Season> get seasonList => _seasonList;
  void addSeason(Season season) {
    _seasonList.add(season);
    notifyListeners();
  }
  void removeSeason(int index) {
    if (index >= 0 && index < _seasonList.length) {
      _seasonList.removeAt(index);
      notifyListeners();
    }
  }



  Future<bool> Step3API() async {
    _pageStatus = DefaultPageStatus.loading;
    notifyListeners();
    bool validate = validateFields();
    if (!validate) {
      _pageStatus = DefaultPageStatus.failed;
      notifyListeners();
      throw Exception('Validation failed. Please check the input fields.');
    }
print("trailer type :${_trailerType}");

      await _multipleFileUploadMainRepo.step3API(
          isFile: _trailerType == 'File',
          singleMediaFile: _trailerMediaFile,
          singleMediaLink: _trailerMediaLink);
      return true;

  }

  String _trailerType = 'file';

  String get trailerType => _trailerType;

  set settrailerType(String value) {
    _trailerType = value;
    notifyListeners();
  }

  bool validateFields() {
    // Check if the trailer type is selected
    if (_trailerType.isEmpty || _title.isEmpty || _year.isEmpty) {
      return false;
    }

    // Check that either the trailer link or the file is provided, not both
    if (_trailerType == "Url" && _trailerMediaLink.isEmpty) {
      return false;
    } else if (_trailerType == "File" && _trailerMediaFile == null) {
      return false;
    }

    return true;
  }
}

class Season {
  final TextEditingController titleController = TextEditingController();
  final String year = '';
  final TextEditingController trailerMediaLinkController =
      TextEditingController();
  File? imageFile;
  Uint8List? thumbnailDataTrailer;

  Season();
}
