import 'dart:io';

import 'package:flutter/cupertino.dart';

class RcRoundUploadProvider with ChangeNotifier{

  File? _selectedFile;

  File? get selectedFile => _selectedFile;

  File? _thumbnailFile;
  File? get thumbnailFile => _thumbnailFile;

  set setselectedFile(File value) {
    print("Uploaded File is :$_selectedFile");

    _selectedFile = value;
    notifyListeners();
  }



  set setthumbnailFile(File value) {
    _thumbnailFile = value;
    print("Thumbnail Set");
    notifyListeners();
  }

  Future<void>saveRoundMedia()async{}
  Future<void>editRoundMedia()async{}
}