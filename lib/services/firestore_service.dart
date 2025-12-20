import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  CollectionReference? _classifications;

  FirestoreService() {
    _init();
  }

  void _init() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _classifications = FirebaseFirestore.instance.collection('classifications');
      }
    } catch (e) {
      debugPrint("Firestore initialization failed: $e");
    }
  }

  Future<void> logClassification({
    required String className,
    required double confidence,
    required String source,
  }) async {
    if (_classifications == null) {
      debugPrint("Firestore not initialized, skipping log.");
      return;
    }
    try {
      await _classifications!.add({
        'className': className,
        'confidence': confidence,
        'source': source,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Classification logged to Firestore");
    } catch (e) {
      debugPrint("Error logging classification: $e");
    }
  }

  Stream<QuerySnapshot> getClassifications() {
    if (_classifications == null) {
      return const Stream.empty();
    }
    return _classifications!.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> clearLogs() async {
    if (_classifications == null) return;
    try {
      final snapshots = await _classifications!.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint("Error clearing logs: $e");
    }
  }
}
