import 'dart:io';

import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/multiplefileupload/multiple_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';

class MultipleFileUploadStep2Provider with ChangeNotifier {
  final MultipleFileUploadMainRepo _multipleFileUploadMainRepo = MultipleFileUploadMainRepo();
  String _errorMesssage = '';

  String get errorMesssage => _errorMesssage;

  File? poster;
  File _posterFile = File('');

  File get posterFile => _posterFile;

  set setposterFile(File value) {
    _posterFile = value;
  }

  String _trailerType = 'file';
  TextEditingController trailerLink = TextEditingController();
  File? _pickedFile;

  Future<bool> step2API() async {
    print("Poster File: $_posterFile");
    bool validate = validateFields();
    if (!validate) {
      throw Exception('Validation failed. Please check the input fields.');
    }
    try {
      await _multipleFileUploadMainRepo.step2API(
          isFile: _pickedFile != null,
          poster: _posterFile,
          trailerFile: _pickedFile,
          trailerLink: trailerLink.text
      );
      return true;
    } catch (e) {
      _errorMesssage = e.toString();
      return false;
    }
  }


  String get trailerType => _trailerType;

  File? get pickedFile => _pickedFile;

  bool validateFields() {
    if (_trailerType.isEmpty || _posterFile.path.isEmpty) {
      return false;
    }

    if (_trailerType == "Url" && trailerLink.text.isEmpty) {
      return false;
    } else if (_trailerType == "File" && _pickedFile == null) {
      return false;
    }

    return true;
  }


  set settrailerType(String value) {
    _trailerType = value;
    notifyListeners();
  }

  set setpickedFile(File value) {
    _pickedFile = value;
    notifyListeners();
  }


}
