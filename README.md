# infobootleg

![](https://img.shields.io/github/last-commit/ivov/infobootleg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Mobile app for playing around with data from InfoLeg, Argentina's legislative information service.

Built with Dart/Flutter and Firebase, for Android.

<p align="center">
    <img src="demo/dart.png" width="156">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/flutter.png" width="160">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/firebase.png" width="125">
</p>

## Overview

Android app for retrieving laws from Argentina's [official legislative service](http://www.infoleg.gob.ar) and displaying their data in a user-friendly format, with article-by-article navigation, user authentication and support for favoriting articles and commenting.

<p align="center">
    <img src="demo/overview.gif">
<p>

Features:

- Full text/metadata retrieval from InfoLeg/Firestore
- Sign in via Google, Facebook, e-mail and incognito
- Search using Google Custom Search API
- Auth stream-based redirection flow
- NoSQL CRUD ops for laws and favorites
- HTML scraping and text parsing with RegEx
- State management with `Provider` and callbacks

## Installation

1. Clone repo
2. Get dependencies: `flutter pub get`
3. Run: `flutter run`

## Operation

### Sign-in flow

Sign in using a Google or Facebook account, e-mail/password or anonymously. In all cases, a user doc is created at Firestore to record the articles favorited by the user.

<p align="center">
    <img src="demo/sign_in.png" height="500px">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/sign_in_email.png" height="500px">
</p>

<p align="center">
    <img src="demo/sign_in_with_google.png" height="500px">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/sign_in_with_facebook.png" height="500px">
</p>

Based on Firestore's auth stream, the app redirects a signed-in user to the home screen and a signed-out user to the sign-in page. Signed-in status is preserved.

### Law search

At the main search screen, the user may search for a law by name or by number (vertical navigation), view their favorited articles (horizontal navigation) or sign out.

<p align="center">
    <img src="demo/law_search_screen1.gif">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/law_search_screen2.gif">
<p>

### Law summary

Searching for a law leads to the law summary screen, with Firestore's metadata for the queried law: official title, publication date, originating entity, summary text, etc.

**Modification relations** The laws and regulations that the query modifies and the laws and regulations that are modified by the query are accessed by tapping on the bottom icons.

<p align="center">
    <img src="demo/law_summary_screen.gif">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/modification_relations_dialog.gif">
<p>

### Law text

At the law summary screen, pressing the big green button brings up the law text screen, with InfoLeg's full text of the law parsed into articles, including a table of contents for ease of navigation.

**Favoriting articles** Long-pressing an article triggers a prompt for saving it as a user's favorite. Long-pressing a favorited article prompts for removal of the favorite.

<p align="center">
    <img src="demo/law_text_screen.gif">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/article_favoriting.gif">
<p>

### Favorites list

Back at the main search screen, the favorites button leads to the favorites list, which displays every article favorited by the user, including any comments added, also with a table of contents.

**Commenting on favorites** Tapping on the pen icon of a favorite leads to the comment screen, for commenting on the favorite. Save the comment using the keyboard; delete it using the cross icon. Since the favorites list is stream-based, any changes are reflected immediately.

<p align="center">
    <img src="demo/favorites_list.gif">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/commenting_favorites.gif">
<p>

### RegEx exceptions

Given InfoLeg's inconsistent formatting, it is expected that RegEx parsing may fail with a number of laws, in which case the native mobile browser is launched.

<p align="center">
    <img src="demo/formatting_exception1.png" height="500px">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="demo/formatting_exception2.png" height="500px">
</p>

## TODOs

- Add tests!
- More exception handling.
- More RegEx patterns.
- Maybe favoriting entire laws.

## Author

© 2020 Iván Ovejero

## License

Distributed under the MIT License. See [LICENSE.md](LICENSE.md)
