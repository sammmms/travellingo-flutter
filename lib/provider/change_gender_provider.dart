import 'package:flutter/foundation.dart';

class ChangeGenderProvider extends ChangeNotifier {
  String currentGender;

  ChangeGenderProvider({required this.currentGender});

  void changeGender(String newGender) {
    currentGender = newGender;
    notifyListeners();
  }
}
