import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/multiplefileupload/multiple_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';

class MultipleFileUploadStep1Provider with ChangeNotifier{
  MultipleFileUploadMainRepo _multipleFileUploadMainRepo = MultipleFileUploadMainRepo();
  String _dtId = '';

  set setdtId(String value) {
    _dtId = value;
  }

  String get dtId => _dtId;
  int _category = 0;

  TextEditingController title = TextEditingController();
  String _year = '';
  String _certificate = 'UA';
  int _hours = 0;
  int _minutes = 2;
  int _genre = 0;
  int _language = 0;
  TextEditingController storyLine = TextEditingController();

  Future<bool> Step1API() async {
    bool isValid = ValidatingTheFields();

    if (!isValid) {
      throw Exception('Validation failed. Please check the input fields.');
    }

    try {
      await _multipleFileUploadMainRepo.step1API(
          title: title.text,
          category: _category.toString(),
          genre: _genre.toString(),
          certificate: _certificate,
          hour: _hours,
          minute: _minutes,
          language: _language.toString(),
          storyLine: storyLine.text,
          year: _year);
      return true;
    } catch (error) {
      print('Error sending movie data: $error');
      return false;
    }
  }

  int get category => _category;

  String get year => _year;

  String get certificate => _certificate;

  int get hours => _hours;

  int get minutes => _minutes;

  int get genre => _genre;

  int get language => _language;

  set setcategory(int value) {
    _category = value;
  }

  set setlanguage(int value) {
    _language = value;
  }

  set setgenre(int value) {
    _genre = value;
  }

  set setminutes(int value) {
    _minutes = value;
  }

  set sethours(int value) {
    _hours = value;
  }

  set setcertificate(String value) {
    _certificate = value;
  }

  set setyear(String value) {
    _year = value;
  }

  bool ValidatingTheFields() {
    if (title.text.isEmpty ||
        _year.isEmpty ||

        _genre <= 0 ||
        _language <= 0 ||
        storyLine.text.isEmpty) {
      return false;
    }
    return true;
  }
}

