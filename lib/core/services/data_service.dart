import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generic method to add a document to a collection
  static Future<String> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  /// Generic method to get a document by ID
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  /// Generic method to update a document
  static Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  /// Generic method to delete a document
  static Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  /// Generic method to get all documents from a collection
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (queryBuilder != null) {
        query = queryBuilder(_firestore.collection(collection));
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to get collection: ${e.toString()}');
    }
  }

  /// Listen to real-time updates for a collection
  static Stream<List<Map<String, dynamic>>> streamCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection(collection);

      if (queryBuilder != null) {
        query = queryBuilder(_firestore.collection(collection));
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to stream collection: ${e.toString()}');
    }
  }

  /// Listen to real-time updates for a document
  static Stream<Map<String, dynamic>?> streamDocument({
    required String collection,
    required String docId,
  }) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots().map((
        doc,
      ) {
        if (doc.exists) {
          return {'id': doc.id, ...doc.data()!};
        }
        return null;
      });
    } catch (e) {
      throw Exception('Failed to stream document: ${e.toString()}');
    }
  }

  /// Search documents in a collection
  static Future<List<Map<String, dynamic>>> searchDocuments({
    required String collection,
    required String field,
    required dynamic value,
    bool isEqualTo = true,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (isEqualTo) {
        query = query.where(field, isEqualTo: value);
      } else {
        query = query.where(field, isGreaterThanOrEqualTo: value);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to search documents: ${e.toString()}');
    }
  }
}
