import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

/// Simple Firestore helper for reading/writing chat messages.
class FirestoreService {
  FirestoreService() : _messagesRef = FirebaseFirestore.instance.collection('messages');

  final CollectionReference<Map<String, dynamic>> _messagesRef;

  /// Live stream of messages ordered by time.
  Stream<List<Message>> messagesStream() {
    return _messagesRef
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Message.fromDoc).toList());
  }

  /// Adds a new anonymous message.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    await _messagesRef.add({
      'text': trimmed,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes every message in the collection.
  Future<void> clearMessages() async {
    final batch = FirebaseFirestore.instance.batch();
    final query = await _messagesRef.get();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
