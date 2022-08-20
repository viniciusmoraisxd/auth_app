
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/firebase/firebase_database_client.dart';
import '../../domain/helpers/helpers.dart';

class FirebaseDatabaseAdapter implements FirebaseDatabaseClient {
  late final FirebaseFirestore firestore;
  late final FirebaseAuth firebaseAuth;

  FirebaseDatabaseAdapter() {
    firestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future save(
      {required Map<String, dynamic> json, required String collection}) async {
    try {
      if (firebaseAuth.currentUser != null) {
        json.addAll({"uid": firebaseAuth.currentUser!.uid});
        await firestore
            .collection(collection)
            .add(json)
            .timeout(const Duration(seconds: 5));
      } else {
        throw DomainError.accessDenied;

        // Criar Errors no data
      }
    } on FirebaseException {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<QuerySnapshot> load({required String collection}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;

    try {
      if (firebaseAuth.currentUser != null) {
        snapshot = await firestore
            .collection(collection)
            .where("uid", isEqualTo: firebaseAuth.currentUser!.uid)
            .get();
      } else {
        throw DomainError.accessDenied;
      }
    } on FirebaseException {
      throw DomainError.accessDenied;
    }

    return snapshot;
  }
}
