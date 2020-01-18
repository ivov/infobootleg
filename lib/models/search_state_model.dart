import 'package:flutter/widgets.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/models/law_model.dart';

class SearchStateModel extends ChangeNotifier {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  Law _activeLaw;
  Map<String, String> _lawContents = {};
  bool _isLoading = false;

  PageController get pageController => _pageController;
  ScrollController get scrollController => _scrollController;
  Law get activeLaw => _activeLaw;
  Map<String, String> get lawContents => _lawContents;
  bool get isLoading => _isLoading;

  // navigation

  void goToLawSearchScreen() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

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

  void goToArticle() {
    _scrollController.animateTo(
      800,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  // activeLaw and lawContents

  void updateActiveLaw(Law newLaw) async {
    _activeLaw = newLaw;
    notifyListeners();
  }

  Future<void> updateLawContents() async {
    Map<String, String> retrievedlawContents =
        await Retriever.retrieveLawText(url: activeLaw.link);
    _lawContents = retrievedlawContents;

    notifyListeners();
  }

  // loading state

  void toggleLoadingState() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
