import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:flutter/material.dart';

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
          .limit(1)
          .get();

      if (query.docs.isEmpty) return [];

      final cartDoc = query.docs.first;
      final data = cartDoc.data();

      final Map<String, dynamic> productsMap =
          Map<String, dynamic>.from(data['products'] ?? {});

      final List<Map<String, dynamic>> result = [];

      for (final entry in productsMap.entries) {
        final productId = entry.key;
        final quantity = entry.value ?? 1;

        final productSnap =
            await _firestore.collection('products').doc(productId).get();

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
  Future<void> addProductToCart(
    String productId,
    BuildContext ctx,
    int requiredQuantity,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      final cartQuery = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .limit(1)
          .get();

      if (cartQuery.docs.isEmpty) {
        final productSnap =
            await _firestore.collection('products').doc(productId).get();
        if (!productSnap.exists) throw Exception("Product not found.");

        final int available = productSnap.data()!['quantity'] ?? 0;
        if (available < requiredQuantity) {
          throw Exception("Not enough stock!");
        }

        await _firestore.collection('carts').add({
          'userIds': [user.uid],
          'products': {productId: requiredQuantity},
        });
        return;
      }

      final cartRef = cartQuery.docs.first.reference;

      // Run transaction
      await _firestore.runTransaction((transaction) async {
        final cartSnap = await transaction.get(cartRef);
        final Map<String, dynamic> products =
            Map<String, dynamic>.from(cartSnap.data()?['products'] ?? {});

        final productRef = _firestore.collection('products').doc(productId);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) throw Exception("Product not found.");

        final int available = productSnap.data()?['quantity'] ?? 0;
        final int currentInCart = products[productId] ?? 0;
        int newQuantity = currentInCart + requiredQuantity;

        if (newQuantity > available) {
          newQuantity = available;
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text("Only $available items available.")),
          );
        }

        products[productId] = newQuantity;
        transaction.update(cartRef, {'products': products});
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Clear cart for a user
  Future<void> clearCart(String userId) async {
    final cartRef =
        FirebaseFirestore.instance.collection("carts").doc(userId).collection("items");

    final items = await cartRef.get();
    for (var doc in items.docs) {
      await doc.reference.delete();
    }
  }

  /// Fetch all shared carts
  Future<List<Map<String, dynamic>>> getSharedCarts() async {
    try {
      final query = await _firestore.collection('carts').get();
      if (query.docs.isEmpty) return [];

      final Map<String, int> allProductsMap = {};
      final Set<String> allUserIds = {};

      for (final cartDoc in query.docs) {
        final data = cartDoc.data();
        final productsData = data['products'];
        final userIds = (data['userIds'] as List<dynamic>?) ?? [];
        allUserIds.addAll(userIds.cast<String>());

        if (productsData == null) continue;

        final productsMap = Map<String, dynamic>.from(productsData);

        for (final entry in productsMap.entries) {
          final productId = entry.key;
          final quantity = (entry.value as num?)?.toInt() ?? 1;

          allProductsMap[productId] =
              (allProductsMap[productId] ?? 0) + quantity;
        }
      }

      final List<Map<String, dynamic>> productsList = [];

      for (final entry in allProductsMap.entries) {
        final productSnap =
            await _firestore.collection('products').doc(entry.key).get();

        if (productSnap.exists && productSnap.data() != null) {
          final product = Product.fromMap(productSnap.data()!, productSnap.id);
          productsList.add({'product': product, 'quantity': entry.value});
        }
      }

      return [
        {'products': productsList, 'userIds': allUserIds.toList()},
      ];
    } catch (e) {
      rethrow;
    }
  }

  /// Decrease product quantity in cart or remove if zero
  Future<void> decreaseProductQuantityCart(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      final cartQuery = await _firestore
          .collection('carts')
          .where('userIds', arrayContains: user.uid)
          .limit(1)
          .get();

      if (cartQuery.docs.isEmpty) return;

      final cartRef = cartQuery.docs.first.reference;

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(cartRef);
        final data = snapshot.data() ?? {};
        final Map<String, dynamic> products =
            Map<String, dynamic>.from(data['products'] ?? {});

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
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return {'initialTotal': 0.0, 'discountedTotal': 0.0};
      }

      final cartDoc = query.docs.first;
      final data = cartDoc.data();
      final Map<String, dynamic> productsMap =
          Map<String, dynamic>.from(data['products'] ?? {});

      double initialTotal = 0.0;
      double discountedTotal = 0.0;

      for (final entry in productsMap.entries) {
        final productId = entry.key;
        final quantity = (entry.value ?? 1) as int;

        final productSnap =
            await _firestore.collection('products').doc(productId).get();

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

/// Cart model
class Cart {
  final String cartId;
  final List<String> userIds;
  final Map<String, int> products;

  Cart({
    required this.cartId,
    required this.userIds,
    required this.products,
  });

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'userIds': userIds,
        'products': products,
      };

  factory Cart.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final Map<String, int> parsedProducts = {};

    if (rawProducts is Map) {
      rawProducts.forEach((key, value) {
        if (key != null) {
          parsedProducts[key.toString()] =
              (value is int) ? value : int.tryParse(value.toString()) ?? 1;
        }
      });
    }

    return Cart(
      cartId: json['cartId']?.toString() ?? '',
      userIds: (json['userIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      products: parsedProducts,
    );
  }
}
