// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/singlefileupload/single_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';

class Step2SFUploadProvider with ChangeNotifier {
  final SingleFileUploadMainRepo _singleFileUploadMainRepo = SingleFileUploadMainRepo();
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

    // Validate fields first
    bool validate = validateFields();
    if (!validate) {
      print("Validation failed in step2API");
      throw Exception('Validation failed. Please check the input fields.');
    }

    try {
      // Ensure either file or URL is available, and handle accordingly
      bool isFileAvailable = _posterFile != null;
      bool isTrailerAvailable = _pickedFile != null || trailerLink.text.isNotEmpty;

      if (!isFileAvailable && !isTrailerAvailable) {
        throw Exception('Either poster file or trailer link must be provided.');
      }

      print("""
      isFile: $isFileAvailable,
      poster: $_posterFile,
      trailerFile: $_pickedFile,
      trailerLink: ${trailerLink.text}
    """);

      await _singleFileUploadMainRepo.step2API(
        isFile: isFileAvailable,
        poster: _posterFile,
        trailerFile: _pickedFile,
        trailerLink: trailerLink.text,
      );

      print("step2API success");
      return true;
    } catch (e) {
      _errorMesssage = e.toString();
      print("step2API error: $e");
      return false;
    }
  }




  String get trailerType => _trailerType;

  File? get pickedFile => _pickedFile;

  bool validateFields() {
    // Check if the trailer type is selected
    if (_trailerType.isEmpty || _posterFile.path.isEmpty) {
      return false;
    }

    // Check that either the trailer link or the file is provided, not both
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

  set setpickedFile(File? value) {
    _pickedFile = value;
    notifyListeners();
  }


}
