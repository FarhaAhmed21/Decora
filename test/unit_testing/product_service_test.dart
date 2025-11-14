import 'package:decora/src/features/product_details/services/product_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';

void main() {
  group('ProductService Unit Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProductService productService;

    setUp(() async {
      // Initialize fake Firestore
      fakeFirestore = FakeFirebaseFirestore();

      // Fill it with fake product documents
      await fakeFirestore.collection('products').doc('1').set({
        'name': 'Wooden Chair',
        'extraInfo': 'Solid oak chair',
        'details': 'Comfortable wooden chair',
        'price': 150.0,
        'discount': 10,
        'quantity': 5,
        'isNewCollection': true,
        'categories': 'Furniture',
        'colors': [
          {
            'colorName': 'Brown',
            'hexColor': '#A0522D',
            'imageUrl': 'https://example.com/chair_brown.png'
          }
        ],
        'comments': [
          {'text': 'Nice chair!', 'date': '2025-11-10', 'userid': 'user123'}
        ],
      });

      await fakeFirestore.collection('products').doc('2').set({
        'name': 'Lamp',
        'extraInfo': 'LED bulb included',
        'details': 'Modern lamp',
        'price': 300.0,
        'discount': 0,
        'quantity': 10,
        'isNewCollection': false,
        'categories': 'Lighting',
        'colors': [
          {
            'colorName': 'White',
            'hexColor': '#FFFFFF',
            'imageUrl': 'https://example.com/lamp_white.png'
          }
        ],
        'comments': [],
      });

      // Inject fake Firestore into ProductService
      productService = ProductService.forTest(fakeFirestore);
    });

    test('getProducts() should return all products', () async {
      final products = await productService.getProducts();
      expect(products.length, 2);
      expect(products.first.name, 'Wooden Chair');
    });

    test('getDiscountedProducts() should return only discounted products', () async {
      final discounted = await productService.getDiscountedProducts();
      expect(discounted.length, 1);
      expect(discounted.first.discount, 10);
    });

    test('getNewCollectionProducts() should return only new collection products', () async {
      final newCollection = await productService.getNewCollectionProducts();
      expect(newCollection.length, 1);
      expect(newCollection.first.isNewCollection, true);
    });

    test('fetchComments() should return the product comments', () async {
      final product = Product.fromMap({
        'name': 'Wooden Chair',
        'extraInfo': '',
        'details': '',
        'price': 150.0,
        'discount': 10,
        'quantity': 5,
        'isNewCollection': true,
        'categories': 'Furniture',
        'colors': [],
        'comments': [],
      }, '1');

      final comments = await productService.fetchComments(product);
      expect(comments.length, 1);
      expect(comments.first.text, 'Nice chair!');
    });

    test('addComment() should append new comment', () async {
      final comment = Comment(
        text: 'Great product!',
        date: '2025-11-13',
        userid: 'user456',
      );

      await productService.addComment(productId: '1', comment: comment);

      final snapshot = await fakeFirestore.collection('products').doc('1').get();
      final data = snapshot.data()!;
      final comments = List<Map<String, dynamic>>.from(data['comments']);
      expect(comments.any((c) => c['text'] == 'Great product!'), true);
    });
  });
}
