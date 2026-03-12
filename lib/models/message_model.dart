import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single anonymous message.
class Message {
  Message({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  final String id;
  final String text;
  final DateTime timestamp;

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Message(
      id: doc.id,
      text: (data['text'] as String? ?? '').trim(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
