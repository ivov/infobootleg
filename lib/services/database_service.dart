import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:infobootleg/models/law_model.dart';

class DatabaseService {
  DatabaseService({@required this.userId}) : assert(userId != null);
  final String userId;

  Future<Law> retrieveLaw(String documentID) {
    return Firestore.instance
        .collection('laws')
        .document(documentID)
        .get()
        .then((snapshot) => Law(snapshot.data));
  }
}

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

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'Law.dart';

// class DB {
//   static Future<Law> retrieveLaw(String documentID) {
//     return Firestore.instance
//         .collection('laws')
//         .document(documentID)
//         .get()
//         .then((snapshot) => Law.fromFirestore(snapshot));
//   }
// }
