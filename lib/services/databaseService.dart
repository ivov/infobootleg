import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:infobootleg/models/api_path.dart';
import 'package:infobootleg/screens/job.dart';

abstract class DatabaseService {
  Future<void> createJob(Job job);
}

class FirestoreDatabaseService implements DatabaseService {
  FirestoreDatabaseService({@required this.uid}) : assert(uid != null);
  final String uid;

  @override
  Future<void> createJob(Job job) async => _setData(
        path: APIPath.job(uid, "job_abc"),
        data: job.toMap(),
      );

  // single entry point for all writes to Firestore
  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Stream<List<Job>> jobsStream() => _collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );

  Stream<List<T>> _collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map(
      (snapshot) =>
          snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
    );
  }
}
