import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/cart/model/cart_model.dart'; // 👈 adjust to your actual import path

void main() {
  group('🧪 Cart Model Unit Tests', () {
    test('fromJson should correctly create Cart object with valid data', () {
      final json = {
        'cartId': 'c1',
        'userIds': ['u1', 'u2'],
        'isShared': true,
        'products': {'p1': 2, 'p2': 5},
      };

      final cart = Cart.fromJson(json);

      expect(cart.cartId, 'c1');
      expect(cart.userIds, ['u1', 'u2']);
      expect(cart.isShared, true);
      expect(cart.products, {'p1': 2, 'p2': 5});
    });

    test('toJson should correctly convert Cart object to JSON', () {
      final cart = Cart(
        cartId: 'c1',
        userIds: ['u1', 'u2'],
        isShared: true,
        products: {'p1': 2, 'p2': 5},
      );

      final json = cart.toJson();

      expect(json['cartId'], 'c1');
      expect(json['userIds'], ['u1', 'u2']);
      expect(json['isShared'], true);
      expect(json['products'], {'p1': 2, 'p2': 5});
    });

    test('fromJson should handle missing or null fields safely', () {
      final json = {}; // empty map

      final cart = Cart.fromJson(json);

      expect(cart.cartId, '');
      expect(cart.userIds, isEmpty);
      expect(cart.isShared, false);
      expect(cart.products, isEmpty);
    });

    test('fromJson should handle mixed type values in products', () {
      final json = {
        'cartId': 'c1',
        'userIds': ['u1'],
        'isShared': false,
        'products': {
          'p1': '3', // string value
          'p2': 2,   // int value
          'p3': null, // null value
        },
      };

      final cart = Cart.fromJson(json);

      expect(cart.products['p1'], 3);
      expect(cart.products['p2'], 2);
      expect(cart.products['p3'], 1); // defaults to 1 when null or invalid
    });
  });
}
