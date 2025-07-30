// lib/data/firebase/commissioner_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateCommissionerProfile({
    required String name,
    required String bio,
    required String contact,
  }) async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) throw Exception('User not logged in');

    final docRef = _firestore.collection('commissioners').doc(uid);

    await docRef.set({
      'name': name,
      'bio': bio,
      'contact': contact,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getCommissionerProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('commissioners').doc(uid).get();
    return doc.data();
  }
}
