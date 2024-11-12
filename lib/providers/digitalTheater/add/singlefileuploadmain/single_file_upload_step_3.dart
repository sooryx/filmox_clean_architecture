import 'dart:io';

import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/singlefileupload/single_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';

class Step3DTSFUploadProvider with ChangeNotifier {
  final SingleFileUploadMainRepo _singleFileUploadMainRepo = SingleFileUploadMainRepo();

  String _singleMediaType = 'file';

  String get singleMediaType => _singleMediaType;
  TextEditingController singleMediaLink = TextEditingController();
  File? _pickedFile;

  File? get pickedFile => _pickedFile;

  Future<bool> Step3API() async {
    bool validate = validateFields();

    print("""
      singlemedia type: $_singleMediaType,
      singlemedia file: $_pickedFile,
      singlemedia link: ${singleMediaLink.text}
    """);
    if (!validate) {
      print("Exception failed");
      throw Exception('Validation failed. Please check the input fields.');
    }



    if (_pickedFile != null || (_singleMediaType == 'File')) {

        await _singleFileUploadMainRepo.step3API(
            isFile: _pickedFile != null,
            singleMediaFile: _pickedFile,
            singleMediaLink: '' );
        return true;

    } else {
      await _singleFileUploadMainRepo.step3API(
          isFile: _pickedFile == null,
          singleMediaFile: null,
          singleMediaLink: singleMediaLink.text);
      return true;
    }

  }


  bool validateFields() {
    if (_singleMediaType.isEmpty) {
      return false;
    }

    if (_singleMediaType == "Url" && singleMediaLink.text.isEmpty) {
      return false;
    } else if (_singleMediaType == "File" && _pickedFile == null) {
      return false;
    }

    return true;
  }

  set setMovietype(String value) {
    _singleMediaType = value;
    notifyListeners();
  }

  set setPickedFile(File? value) {
    _pickedFile = value;
    notifyListeners();
    print("Picked File :$_pickedFile");
  }
}
