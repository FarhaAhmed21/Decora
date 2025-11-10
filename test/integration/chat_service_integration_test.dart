import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/chat/repository/chat_service.dart';

import '../mocks.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late ChatService chatService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    chatService = ChatService(firestore: mockFirestore);
  });

  test('sendMessage and sendMessageFromAdmin simulate full flow', () async {
    final mockChatsCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockChatDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockMessagesCollection =
        MockCollectionReference<Map<String, dynamic>>();
    final mockMessageDoc = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('chats')).thenReturn(mockChatsCollection);
    when(mockChatsCollection.doc(any)).thenReturn(mockChatDoc);

    when(mockChatDoc.collection('messages')).thenReturn(mockMessagesCollection);
    when(mockMessagesCollection.doc(any)).thenReturn(mockMessageDoc);
    when(mockMessageDoc.set(any)).thenAnswer((_) async => Future.value());

    when(
      mockMessagesCollection.add(any),
    ).thenAnswer((_) async => mockMessageDoc);

    when(mockChatDoc.set(any, any)).thenAnswer((_) async => Future.value());

    await chatService.sendMessage('user1', 'admin1', 'Hello User');

    await chatService.sendMessageFromAdmin('admin1', 'user1', 'Hello Admin');

    verify(mockFirestore.collection('chats')).called(greaterThanOrEqualTo(2));
    verify(mockChatDoc.collection('messages')).called(greaterThanOrEqualTo(1));
    verify(mockMessageDoc.set(any)).called(1);
    verify(mockMessagesCollection.add(any)).called(1);
    verify(mockChatDoc.set(any, any)).called(greaterThanOrEqualTo(1));
  });

  test('getMessages returns empty list when snapshot empty', () async {
    final mockChatsCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockChatDoc = MockDocumentReference<Map<String, dynamic>>();
    final mockMessagesCollection =
        MockCollectionReference<Map<String, dynamic>>();

    when(mockFirestore.collection('chats')).thenReturn(mockChatsCollection);
    when(mockChatsCollection.doc(any)).thenReturn(mockChatDoc);
    when(mockChatDoc.collection('messages')).thenReturn(mockMessagesCollection);

    when(
      mockMessagesCollection.orderBy('timestamp', descending: false),
    ).thenReturn(mockMessagesCollection);

    when(
      mockMessagesCollection.snapshots(),
    ).thenAnswer((_) => Stream.value(MockQuerySnapshot()));

    final messagesStream = chatService.getMessages('user1', 'admin1');
    final messages = await messagesStream.first;

    expect(messages, isEmpty);
  });
}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => [];
}
