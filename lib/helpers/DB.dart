import 'package:cloud_firestore/cloud_firestore.dart';

import 'Law.dart';

class DB {
  static Future<Law> retrieveLaw(String documentID) {
    return Firestore.instance
        .collection('laws')
        .document(documentID)
        .get()
        .then((snapshot) => Law.fromFirestore(snapshot));
  }
}
