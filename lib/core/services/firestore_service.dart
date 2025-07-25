import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/place_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateCommissionerProfile({
    required String name,
    required String bio,
    required String contact,
  }) async {
    final uid = _auth.currentUser?.uid;
    print("Current UID: $uid"); // Add this


    if (uid == null) {
      throw Exception("No authenticated user.");
    }

    await _firestore.collection('commissioners').doc(uid).set({
      'name': name,
      'bio': bio,
      'contact': contact,
    }, SetOptions(merge: true)); // merge keeps old fields
  }
}
