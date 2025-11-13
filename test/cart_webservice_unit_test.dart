import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/cart/service/service.dart';

void main() {
  late CartRepository cartRepository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockCollectionReference mockCollection;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockCollection = MockCollectionReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();

    cartRepository = CartRepository(firestore: mockFirestore, auth: mockAuth);

    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user1');

    when(() => mockFirestore.collection('carts')).thenReturn(mockCollection);
    when(
      () => mockCollection.where(
        any(),
        arrayContains: any(named: 'arrayContains'),
      ),
    ).thenReturn(mockQuery);
    when(
      () => mockQuery.where(any(), isEqualTo: any(named: 'isEqualTo')),
    ).thenReturn(mockQuery);
    when(() => mockQuery.limit(1)).thenReturn(mockQuery);
    when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(() => mockQuerySnapshot.docs).thenReturn([]);
  });

  group('CartRepository Unit Tests', () {
    test('getPersonalCartProducts returns empty list when no cart', () async {
      final result = await cartRepository.getPersonalCartProducts();
      expect(result, isEmpty);
    });

    test('getCartTotals returns 0.0 when cart is empty', () async {
      final totals = await cartRepository.getCartTotals();
      expect(totals['initialTotal'], 0.0);
      expect(totals['discountedTotal'], 0.0);
    });
  });
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}
