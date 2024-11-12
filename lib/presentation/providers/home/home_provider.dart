import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  bool _isAnimated = false;
  bool get isAnimated => _isAnimated;



  void stopAnimation() {
    print("Animation Value :$_isAnimated");
    _isAnimated = true;
    notifyListeners();
  }
}
