import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatId(String userId, String adminId) {
    return userId.hashCode <= adminId.hashCode
        ? '${userId}_$adminId'
        : '${adminId}_$userId';
  }

  Future<void> sendMessage(String userId, String adminId, String text) async {
    final chatId = getChatId(userId, adminId);
    final message = ChatMessage(
      id: '',
      text: text,
      senderId: userId,
      timestamp: Timestamp.now(),
    );

    final docRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();
    await docRef.set(message.toMap());

    await _firestore.collection('chats').doc(chatId).set({
      'participants': [userId, adminId],
    }, SetOptions(merge: true));
  }

  Stream<List<ChatMessage>> getMessages(String userId, String adminId) {
    final chatId = getChatId(userId, adminId);
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatMessage.fromDoc(doc)).toList(),
        );
  }

  Future<void> sendMessageFromAdmin(
    String adminId,
    String userId,
    String text,
  ) async {
    final chatId = getChatId(userId, adminId);
    final message = {
      'text': text,
      'senderId': adminId,
      'receiverId': userId,
      'timestamp': Timestamp.now(),
      'isRead': false,
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);

    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'participants': [userId, adminId],
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
