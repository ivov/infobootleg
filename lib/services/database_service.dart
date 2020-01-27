import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infobootleg/models/favorite_model.dart';

class DatabaseService {
  DatabaseService({@required this.currentUserID})
      : currentUserDoc = usersColl.document(currentUserID);

  String currentUserID;
  DocumentReference currentUserDoc;

  static final CollectionReference lawsColl =
      Firestore.instance.collection('laws');

  static final CollectionReference usersColl =
      Firestore.instance.collection('users');

  // laws

  Future<QuerySnapshot> readAllLaws() async {
    return lawsColl.getDocuments();
  }

  Future<DocumentSnapshot> readLaw({@required String id}) async {
    return lawsColl.document(id).get();
  }

  // users (favorited articles)

  Future<DocumentSnapshot> readAllFavoritesOfUser() async {
    return currentUserDoc.get();
  }

  Stream<DocumentSnapshot> streamAllFavoritesOfUser() {
    return currentUserDoc.snapshots();
  }

  Future<void> saveFavorite(Favorite favorite) async {
    return currentUserDoc.setData(favorite.toMap(), merge: true);
    // The flag `merge: true` prevents this favorite from overwriting other favorites in same user document.
  }

  Future<void> deleteFavorite(Favorite favorite) async {
    return currentUserDoc.updateData({
      favorite.lawAndArticle: FieldValue.delete(),
    });
  }

  /// Adds a `comment` field to, or edits the `comment` field in, a favorite in the current user's document.
  /// ```
  /// {
  ///   "20305&33": {"articleText": "Lorem ipsum...", "comment": "It's great"}, // favorite 1
  ///   "11723&13": {"articleText": "Sit amet...", "comment": "It's terrible"} // favorite 2
  /// };
  /// ```
  Future<void> addCommentToFavorite(Favorite favorite, String comment) {
    return currentUserDoc.updateData({
      favorite.lawAndArticle: {
        "articleText": favorite.articleText,
        "comment": comment,
      }
    });
  }

  Future<void> deleteCommentFromFavorite(Favorite favorite, String comment) {
    return currentUserDoc.updateData({
      favorite.lawAndArticle: {
        "articleText": favorite.articleText,
        "comment": FieldValue.delete(),
      }
    });
  }
}
