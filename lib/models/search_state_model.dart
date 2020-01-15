import 'package:flutter/widgets.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/models/law_model.dart';

class SearchStateModel extends ChangeNotifier {
  final PageController _pageController = PageController();
  Law _activeLaw;
  Map<String, String> _lawContents = {};
  bool _isLoading = false;

  PageController get pageController => _pageController;
  Law get activeLaw => _activeLaw;
  Map<String, String> get lawContents => _lawContents;
  bool get isLoading => _isLoading;

  void goToLawSummaryScreen() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  void goToLawTextScreen() {
    pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  void updateActiveLaw(Law newLaw) async {
    _activeLaw = newLaw;
    // TODO: Move this call and its resulting object to appropriate button.
    Map<int, Map<String, String>> allRows =
        await Retriever.retrieveModificationRelations(
      fullTextUrl: activeLaw.link,
      relationType: "isModifiedBy",
    );
    notifyListeners();
  }

  Future<void> updateLawContents() async {
    Map<String, String> retrievedlawContents =
        await Retriever.retrieveLawText(url: activeLaw.link);
    _lawContents = retrievedlawContents;

    notifyListeners();
  }

  void toggleLoadingState() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
