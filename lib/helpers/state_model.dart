import 'package:flutter/foundation.dart';
import 'package:infobootleg/helpers/Law.dart';

class StateModel extends ChangeNotifier {
  Law currentLaw = Law.fromEmpty();

  void setCurrentLaw(Law chosenLaw) {
    currentLaw = chosenLaw;
    print(chosenLaw);
    notifyListeners();
  }
}
