import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/cart/model/cart_model.dart';


// flutter test test/cart_model_unit_test.dart

void main() {
  group('Cart Model Unit Tests', () {

    test('fromJson creates Cart correctly with valid data', () {
      final Map<String, dynamic> json = {
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

    test('toJson converts Cart object to JSON correctly', () {
      final cart = Cart(
        cartId: 'c1',
        userIds: ['u1', 'u2'],
        isShared: true,
        products: {'p1': 2, 'p2': 5},
      );

      final Map<String, dynamic> json = cart.toJson();

      expect(json['cartId'], 'c1');
      expect(json['userIds'], ['u1', 'u2']);
      expect(json['isShared'], true);
      expect(json['products'], {'p1': 2, 'p2': 5});
    });
  });
}


