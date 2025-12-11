import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';

// -------------------- Mock Classes --------------------
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

// -------------------- Main Tests --------------------
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

  group('CartRepository Unit Tests', () {
    test('calculateTotal → returns correct totals', () {
      final items = [
        {
          'product': Product(
            id: '1',
            name: 'Test',
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

      final result = repository.calculateTotal(items);

      expect(result['initialTotal'], 200.0);
      expect(result['discountedTotal'], closeTo(180.0, 0.01));
    });

    test('getPersonalCartProducts → returns empty when no cart exists', () async {
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();

      when(() => firestore.collection('carts')).thenReturn(mockCartsCollection);
      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      final result = await repository.getPersonalCartProducts();

      expect(result, isEmpty);
    });

    test('getPersonalCartProducts → returns products correctly', () async {
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
      when(() => firestore.collection('products')).thenReturn(mockProductsCollection);
      when(() => mockCartsCollection.where(
            'userIds',
            arrayContains: any(named: 'arrayContains'),
          )).thenReturn(mockQuery);
      when(() => mockQuery.limit(1)).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
      when(() => mockQueryDoc.data()).thenReturn(cartData);

      when(() => mockProductsCollection.doc('p1')).thenReturn(mockProductDocRef);
      when(() => mockProductDocRef.get()).thenAnswer((_) async => mockProductSnap);
      when(() => mockProductSnap.exists).thenReturn(true);
      when(() => mockProductSnap.data()).thenReturn(productData);
      when(() => mockProductSnap.id).thenReturn('p1');

      final result = await repository.getPersonalCartProducts();

      expect(result.length, 1);
      expect(result.first['quantity'], 2);
      expect(result.first['product'], isA<Product>());
      expect(result.first['product'].name, 'Chair');
    });

    test('getSharedCarts → returns aggregated products correctly', () async {
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockCartDoc1 = MockQueryDocumentSnapshot();
      final mockCartDoc2 = MockQueryDocumentSnapshot();
      final mockProductDocRef1 = MockDocumentReference();
      final mockProductDocRef2 = MockDocumentReference();
      final mockProductSnap1 = MockDocumentSnapshot();
      final mockProductSnap2 = MockDocumentSnapshot();

      final cartData1 = {
        'products': {'p1': 1},
        'userIds': ['user1']
      };
      final cartData2 = {
        'products': {'p2': 2},
        'userIds': ['user2']
      };

      final productData1 = {
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
      };
      final productData2 = {
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
      };

      when(() => firestore.collection('carts')).thenReturn(mockCartsCollection);
      when(() => mockCartsCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockCartDoc1, mockCartDoc2]);
      when(() => mockCartDoc1.data()).thenReturn(cartData1);
      when(() => mockCartDoc2.data()).thenReturn(cartData2);

      when(() => firestore.collection('products')).thenReturn(mockProductsCollection);
      when(() => mockProductsCollection.doc('p1')).thenReturn(mockProductDocRef1);
      when(() => mockProductsCollection.doc('p2')).thenReturn(mockProductDocRef2);

      when(() => mockProductDocRef1.get()).thenAnswer((_) async => mockProductSnap1);
      when(() => mockProductDocRef2.get()).thenAnswer((_) async => mockProductSnap2);

      when(() => mockProductSnap1.exists).thenReturn(true);
      when(() => mockProductSnap1.data()).thenReturn(productData1);
      when(() => mockProductSnap1.id).thenReturn('p1');

      when(() => mockProductSnap2.exists).thenReturn(true);
      when(() => mockProductSnap2.data()).thenReturn(productData2);
      when(() => mockProductSnap2.id).thenReturn('p2');

      final result = await repository.getSharedCarts();

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
