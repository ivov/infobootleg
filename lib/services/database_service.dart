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

  // users (favorites)

  Future<DocumentSnapshot> readAllFavoritesOfUser() async {
    return currentUserDoc.get();
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

  /// Adds a `comment` field to, or edits the `comment` field in, a favorite field in the current user's document.
  /// ```
  /// {
  ///   "20.305&33": {"text": "Lorem ipsum...", "comment": "It's great"}, // favorite 1
  ///   "11.723&13": {"text": "Sit amet...", "comment": "It's terrible"} // favorite 2
  /// };
  /// ```
  Future<void> addCommentToFavorite(Favorite favorite, String comment) {
    return currentUserDoc.updateData({
      favorite.lawAndArticle: {
        "text": favorite.articleText,
        "comment": comment,
      }
    });
  }

  Future<void> deleteCommentFromFavorite(Favorite favorite, String comment) {
    return currentUserDoc.updateData({
      favorite.lawAndArticle: {
        "text": favorite.articleText,
        "comment": FieldValue.delete(),
      }
    });
  }
}

// https://firebase.google.com/docs/firestore/manage-data/add-data
// https://firebase.google.com/docs/firestore/manage-data/delete-data

// @override
// Future<void> createJob(Job job) async => _setData(
//       path: APIPath.job(userId, "job_abc"),
//       data: job.toMap(),
//     );

// single entry point for all writes to Firestore
// Future<void> _setData({String path, Map<String, dynamic> data}) async {
//   final reference = Firestore.instance.document(path);
//   await reference.setData(data);
// }

// Stream<List<Job>> jobsStream() => _collectionStream(
//       path: APIPath.jobs(userId),
//       builder: (data) => Job.fromMap(data),
//     );

// Stream<List<T>> _collectionStream<T>({
//   @required String path,
//   @required T builder(Map<String, dynamic> data),
// }) {
//   final reference = Firestore.instance.collection(path);
//   final snapshots = reference.snapshots();

//   return snapshots.map(
//     (snapshot) =>
//         snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
//   );
// }
