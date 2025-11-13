import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CartRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Fetch personal cart products
  Future<List<Map<String, dynamic>>> getPersonalCartProducts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in.');

      final query = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .where('isShared', isEqualTo: false)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return [];

      final cartDoc = query.docs.first;
      final data = cartDoc.data();

      final Map<String, dynamic> productsMap = Map<String, dynamic>.from(
        data['products'] ?? {},
      );

      final List<Map<String, dynamic>> result = [];

      for (final entry in productsMap.entries) {
        final productId = entry.key;
        final quantity = entry.value ?? 1;

        final productSnap = await _firestore
            .collection('products')
            .doc(productId)
            .get();

        if (productSnap.exists && productSnap.data() != null) {
          final product = Product.fromMap(productSnap.data()!, productSnap.id);
          result.add({'product': product, 'quantity': quantity});
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Add product to cart or increment quantity if already present
  Future<void> addProductToCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      final cartQuery = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .where('isShared', isEqualTo: false)
          .limit(1)
          .get();

      if (cartQuery.docs.isEmpty) {
        await _firestore.collection('carts').add({
          'userIds': [user.uid],
          'isShared': false,
          'products': {productId: 1},
        });
        return;
      }

      final cartRef = cartQuery.docs.first.reference;

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);
        final data = snapshot.data() ?? {};
        final Map<String, dynamic> products = Map<String, dynamic>.from(
          data['products'] ?? {},
        );

        products[productId] = (products[productId] ?? 0) + 1;

        transaction.update(cartRef, {'products': products});
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch shared carts involving the current user
  Future<List<Map<String, dynamic>>> getSharedCarts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in.');

      final query = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .where('isShared', isEqualTo: true)
          .get();

      if (query.docs.isEmpty) return [];

      final List<Map<String, dynamic>> sharedCarts = [];

      for (final cartDoc in query.docs) {
        final data = cartDoc.data();
        final Map<String, dynamic> productsMap = Map<String, dynamic>.from(
          data['products'] ?? {},
        );

        final List<Map<String, dynamic>> productsList = [];

        for (final entry in productsMap.entries) {
          final productId = entry.key;
          final quantity = entry.value ?? 1;

          final productSnap = await _firestore
              .collection('products')
              .doc(productId)
              .get();

          if (productSnap.exists && productSnap.data() != null) {
            final product = Product.fromMap(
              productSnap.data()!,
              productSnap.id,
            );
            productsList.add({'product': product, 'quantity': quantity});
          }
        }

        sharedCarts.add({
          'cartId': cartDoc.id,
          'products': productsList,
          'userIds': List<String>.from(data['userIds'] ?? []),
        });
      }

      return sharedCarts;
    } catch (e) {
      rethrow;
    }
  }

  /// Decrease product quantity in cart or remove if quantity reaches zero
  Future<void> decreaseProductQuantityCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      final cartQuery = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .where('isShared', isEqualTo: false)
          .limit(1)
          .get();

      if (cartQuery.docs.isEmpty) return;

      final cartRef = cartQuery.docs.first.reference;

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);
        final data = snapshot.data() ?? {};
        final Map<String, dynamic> products = Map<String, dynamic>.from(
          data['products'] ?? {},
        );

        if (products[productId] != null) {
          products[productId] = (products[productId] ?? 0) - 1;
          if (products[productId] <= 0) {
            products.remove(productId);
          }
          transaction.update(cartRef, {'products': products});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Calculate total and discounted total for personal cart
  Future<Map<String, double>> getCartTotals() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      final query = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .where('isShared', isEqualTo: false)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return {'initialTotal': 0.0, 'discountedTotal': 0.0};
      }

      final cartDoc = query.docs.first;
      final data = cartDoc.data();

      final Map<String, dynamic> productsMap = Map<String, dynamic>.from(
        data['products'] ?? {},
      );

      double initialTotal = 0.0;
      double discountedTotal = 0.0;

      for (final entry in productsMap.entries) {
        final productId = entry.key;
        final quantity = (entry.value ?? 1) as int;

        final productSnap = await _firestore
            .collection('products')
            .doc(productId)
            .get();

        if (!productSnap.exists || productSnap.data() == null) continue;

        final product = Product.fromMap(productSnap.data()!, productSnap.id);

        final double price = product.price;
        final num discount = product.discount;

        final double totalPrice = price * quantity;
        final double totalAfterDiscount = totalPrice * (1 - (discount / 100));

        initialTotal += totalPrice;
        discountedTotal += totalAfterDiscount;
      }

      return {'initialTotal': initialTotal, 'discountedTotal': discountedTotal};
    } catch (e) {
      rethrow;
    }
  }
}
