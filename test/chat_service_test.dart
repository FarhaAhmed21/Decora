import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:decora/src/features/chat/repository/chat_service.dart';

import 'mocks.mocks.dart'
    show MockDocumentReference, MockCollectionReference, MockFirebaseFirestore;

void main() {
  late MockFirebaseFirestore mockFirestore;
  late ChatService chatService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    chatService = ChatService(firestore: mockFirestore);
  });

  test('sendMessage calls Firestore set', () async {
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

    when(mockChatDoc.set(any, any)).thenAnswer((_) async => Future.value());

    await chatService.sendMessage('user1', 'admin1', 'Hello');

    verify(mockFirestore.collection('chats')).called(2);
    verify(mockChatDoc.collection('messages')).called(1);
    verify(mockMessageDoc.set(any)).called(1);
    verify(mockChatDoc.set(any, any)).called(1);
  });
}
