import 'package:flutter/widgets.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/models/law_model.dart';

enum Screen { search, summary, text, favorites }

class SearchStateModel extends ChangeNotifier {
  Law _activeLaw;
  final PageController _verticalPageViewController = PageController();
  final PageController _horizontalPageViewController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // vertical navigation: search, summary and text

  PageController get verticalPageViewController => _verticalPageViewController;

  void transitionToScreenVertically(Screen screen) {
    Map<Screen, int> indices = {
      Screen.search: 0,
      Screen.summary: 1,
      Screen.text: 2,
    };

    _verticalPageViewController.animateToPage(
      indices[screen],
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  // horizontal navigation: search & favorites

  PageController get horizontalPageViewController =>
      _horizontalPageViewController;

  void transitionToScreenHorizontally(Screen screen) {
    Map<Screen, int> indices = {
      Screen.search: 0,
      Screen.favorites: 1,
    };

    _horizontalPageViewController.animateToPage(
      indices[screen],
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  ScrollController get scrollController => _scrollController;

  void goToArticle() {
    _scrollController.animateTo(
      800,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  // activeLaw and lawContents

  Law get activeLaw => _activeLaw;

  Map<String, String> _lawContents = {};
  Map<String, String> get lawContents => _lawContents;

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

  // loading state for transition from LawSummaryScreen to LawTextScreen

  bool get isLoading => _isLoading;

  void toggleLoadingState() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
