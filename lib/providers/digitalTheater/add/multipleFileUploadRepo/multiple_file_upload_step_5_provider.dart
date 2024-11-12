import 'dart:io';
import 'package:filmox_clean_architecture/data/repositories/digitalTheater/add/multiplefileupload/multiple_file_upload_main_repo.dart';
import 'package:flutter/cupertino.dart';

class MultipleFileUploadStep5Provider with ChangeNotifier {
  final MultipleFileUploadMainRepo _multipleFileUploadMainRepo = MultipleFileUploadMainRepo();

  List<Map<String, String>> crewList = [];

  TextEditingController _name = TextEditingController();
  TextEditingController _role = TextEditingController();
  File? _image;

  Future<bool> Step5Api() async {
    bool isValid = ValidateFields();
    if (!isValid) {
      notifyListeners();

      throw Exception("Please fill all the fields to save your cast");
    }


    try {
      await _multipleFileUploadMainRepo.ste5API(
          name: _name.text, role: _role.text, image: _image!);
      crewList.add({
        "name": _name.text,
        "role": _role.text,
        "image": _image?.path ?? ""
      });
      return true;
    } catch (e) {
      print('Error occurred: $e');
      notifyListeners();
      return false;
    }
  }



  bool ValidateFields() {
    if (_name.text.isEmpty || _role.text.isEmpty || _image == null) {
      return false;
    }
    return true;
  }

  set name(TextEditingController value) {
    _name = value;
    notifyListeners();
  }

  set role(TextEditingController value) {
    _role = value;
    notifyListeners();
  }

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  TextEditingController get getname => _name;

  TextEditingController get getrole => _role;

  File? get getimage => _image;
}
