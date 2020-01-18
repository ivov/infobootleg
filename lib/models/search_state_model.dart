import 'package:flutter/widgets.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/models/law_model.dart';

enum Screen { search, summary, text, favorites }

class SearchStateModel extends ChangeNotifier {
  // vertical navigation

  final PageController _verticalPageViewController = PageController();
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

  // horizontal nagiation

  final PageController _horizontalPageViewController = PageController();
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

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void goToArticle() {
    _scrollController.animateTo(
      800,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  // activeLaw and lawContents

  Law _activeLaw;
  Map<String, String> _lawContents = {};

  Law get activeLaw => _activeLaw;
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

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoadingState() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
