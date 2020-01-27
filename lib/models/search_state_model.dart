import 'package:flutter/widgets.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/models/law_model.dart';

enum Screen { search, summary, text, favorites, comment }

class SearchStateModel extends ChangeNotifier {
  Law _activeLaw;
  final PageController _verticalPageViewController = PageController();
  final PageController _horizontalPageViewController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Map<String, dynamic> _articleToComment = {
    "lawNumber": "",
    "articleNumber": "",
    "articleText": "",
    "favoriteText": RichText,
  };

  // vertical navigation: search, summary, text

  PageController get verticalPageViewController => _verticalPageViewController;

  void transitionVerticallyTo(Screen screen) {
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

  // horizontal navigation: search, favorites, comment

  PageController get horizontalPageViewController =>
      _horizontalPageViewController;

  void transitionHorizontallyTo(Screen screen) {
    Map<Screen, int> indices = {
      Screen.search: 0,
      Screen.favorites: 1,
      Screen.comment: 2,
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

  // article to comment

  Map<String, dynamic> get articleToComment => _articleToComment;

  void updateArticleToComment(Map<String, dynamic> newArticleToComment) {
    _articleToComment = newArticleToComment;
    notifyListeners();
  }
}
