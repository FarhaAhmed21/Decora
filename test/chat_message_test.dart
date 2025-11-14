import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/chat/repository/chat_message.dart';

void main() {
  group('ChatMessage Model Unit Test', () {
    test('toMap() should return correct map', () {
      final timestamp = Timestamp.now();
      final msg = ChatMessage(
        id: '1',
        text: 'Hello',
        senderId: 'user123',
        timestamp: timestamp,
      );

      final map = msg.toMap();

      expect(map['text'], 'Hello');
      expect(map['senderId'], 'user123');
      expect(map['timestamp'], timestamp);
    });

    test('fromDoc() should create ChatMessage from DocumentSnapshot', () {
      final timestamp = Timestamp.now();
      final doc = _FakeDocumentSnapshot({
        'text': 'Hey!',
        'senderId': 'admin001',
        'timestamp': timestamp,
      }, '123');

      final msg = ChatMessage.fromDoc(doc);

      expect(msg.id, '123');
      expect(msg.text, 'Hey!');
      expect(msg.senderId, 'admin001');
      expect(msg.timestamp, timestamp);
    });
  });
}

class _FakeDocumentSnapshot implements DocumentSnapshot {
  final Map<String, dynamic> _data;
  @override
  final String id;

  _FakeDocumentSnapshot(this._data, this.id);

  @override
  Map<String, dynamic>? data() => _data;

  // Unused props
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
