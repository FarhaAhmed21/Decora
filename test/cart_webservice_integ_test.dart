import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/cart/service/service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

void main() {
  late CartRepository repository;
  late MockFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockUser user;
  late MockCollectionReference mockCartsCollection;
  late MockCollectionReference mockProductsCollection;

  setUpAll(() {
    registerFallbackValue(MockDocumentSnapshot());
    registerFallbackValue(MockDocumentReference());
  });

  setUp(() {
    firestore = MockFirebaseFirestore();
    auth = MockFirebaseAuth();
    user = MockUser();
    mockCartsCollection = MockCollectionReference();
    mockProductsCollection = MockCollectionReference();

    repository = CartRepository(firestore: firestore, auth: auth);

    when(() => auth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('user1');
  });

  group('CartRepository Integration Tests', () {
    test('getCartTotals() → returns totals correctly', () async {
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDoc = MockQueryDocumentSnapshot();

      final mockProductDocRef = MockDocumentReference();
      final mockProductSnap = MockDocumentSnapshot();

      final cartData = {'products': {'p1': 2}};
      final productData = {
        'name': 'Chair',
        'extraInfo': 'Wooden',
        'details': 'Comfy chair',
        'price': 100.0,
        'discount': 10,
        'quantity': 5,
        'isNewCollection': false,
        'categories': 'furniture',
        'colors': [],
        'comments': [],
      };

      when(() => firestore.collection('carts')).thenReturn(mockCartsCollection);
      when(() => firestore.collection('products'))
          .thenReturn(mockProductsCollection);

      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.where('isShared', isEqualTo: false))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
      when(() => mockQueryDoc.data()).thenReturn(cartData);
      when(() => mockQueryDoc.id).thenReturn('cart123');

      when(() => mockProductsCollection.doc('p1'))
          .thenReturn(mockProductDocRef);
      when(() => mockProductDocRef.id).thenReturn('p1');
      when(() => mockProductDocRef.get())
          .thenAnswer((_) async => mockProductSnap);

      when(() => mockProductSnap.id).thenReturn('p1');
      when(() => mockProductSnap.exists).thenReturn(true);
      when(() => mockProductSnap.data()).thenReturn(productData);

      final result = await repository.getCartTotals();

      expect(result['initialTotal'], 200.0);
      expect(result['discountedTotal'], closeTo(180.0, 0.01));
    });

    test('getPersonalCartProducts() → returns empty when no cart', () async {
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();

      when(() => firestore.collection('carts')).thenReturn(mockCartsCollection);
      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.where('isShared', isEqualTo: false))
          .thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await repository.getPersonalCartProducts();
      expect(result, isEmpty);
    });
  });
}
