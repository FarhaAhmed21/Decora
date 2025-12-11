import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';

void main() {
  late CartRepository cartRepository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockCollectionReference mockCartsCollection;
  late MockCollectionReference mockProductsCollection;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockCartsCollection = MockCollectionReference();
    mockProductsCollection = MockCollectionReference();

    cartRepository = CartRepository(firestore: mockFirestore, auth: mockAuth);

    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user1');
    when(() => mockFirestore.collection('carts')).thenReturn(mockCartsCollection);
    when(() => mockFirestore.collection('products')).thenReturn(mockProductsCollection);
  });

  group('CartRepository Unit Tests', () {
    test('getPersonalCartProducts returns empty when no cart exists', () async {
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();

      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await cartRepository.getPersonalCartProducts();
      expect(result, isEmpty);
    });

    test('getCartTotals returns 0.0 when cart is empty', () async {
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();

      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final totals = cartRepository.calculateTotal([]); // <-- pass empty list
      expect(totals['initialTotal'], 0.0);
      expect(totals['discountedTotal'], 0.0);
    });

    test('calculateTotal computes correct totals', () {
      final items = [
        {
          'product': Product(
            id: '1',
            name: 'Chair',
            extraInfo: '',
            details: '',
            price: 100.0,
            discount: 10,
            quantity: 7,
            isNewCollection: false,
            category: '',
            colors: [],
            comments: [],
          ),
          'quantity': 2,
        },
      ];

      final result = cartRepository.calculateTotal(items);
      expect(result['initialTotal'], 200.0);
      expect(result['discountedTotal'], closeTo(180.0, 0.01));
    });

    test('getSharedCarts returns aggregated products', () async {
      final mockCartDoc1 = MockQueryDocumentSnapshot();
      final mockCartDoc2 = MockQueryDocumentSnapshot();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockProductDocRef1 = MockDocumentReference();
      final mockProductDocRef2 = MockDocumentReference();
      final mockProductSnap1 = MockDocumentSnapshot();
      final mockProductSnap2 = MockDocumentSnapshot();

      final cartData1 = {'products': {'p1': 1}, 'userIds': ['user1']};
      final cartData2 = {'products': {'p2': 2}, 'userIds': ['user2']};

      when(() => mockCartsCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockCartDoc1, mockCartDoc2]);
      when(() => mockCartDoc1.data()).thenReturn(cartData1);
      when(() => mockCartDoc2.data()).thenReturn(cartData2);

      when(() => mockProductsCollection.doc('p1')).thenReturn(mockProductDocRef1);
      when(() => mockProductsCollection.doc('p2')).thenReturn(mockProductDocRef2);
      when(() => mockProductDocRef1.get()).thenAnswer((_) async => mockProductSnap1);
      when(() => mockProductDocRef2.get()).thenAnswer((_) async => mockProductSnap2);

      when(() => mockProductSnap1.exists).thenReturn(true);
      when(() => mockProductSnap1.data()).thenReturn({
        'name': 'Chair',
        'extraInfo': '',
        'details': '',
        'price': 100.0,
        'discount': 0,
        'quantity': 5,
        'isNewCollection': false,
        'categories': '',
        'colors': [],
        'comments': [],
      });

      when(() => mockProductSnap2.exists).thenReturn(true);
      when(() => mockProductSnap2.data()).thenReturn({
        'name': 'Table',
        'extraInfo': '',
        'details': '',
        'price': 200.0,
        'discount': 10,
        'quantity': 3,
        'isNewCollection': false,
        'categories': '',
        'colors': [],
        'comments': [],
      });

      final result = await cartRepository.getSharedCarts();

      expect(result.length, 1);
      final productsList = result.first['products'] as List;
      expect(productsList.length, 2);
      expect(result.first['userIds'], containsAll(['user1', 'user2']));
    });
  });
}

extension on double {
  operator [](String other) {}
}

// -------------------- Mock Classes --------------------
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
