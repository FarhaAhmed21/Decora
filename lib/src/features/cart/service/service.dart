import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:flutter/material.dart';

class CartRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Simple in-memory cache
  final Map<String, Product> _productCache = {};

  CartRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;


  /// Get products by ids (batched)

  Future<List<Product>> getProductsByIds(List<String> ids) async {
    List<Product> products = [];
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    }

    for (var chunk in chunks) {
      final query = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var doc in query.docs) {
        final product = Product.fromMap(doc.data(), doc.id);
        _productCache[doc.id] = product;
        products.add(product);
      }
    }

    return products;
  }


  /// Fetch personal cart products 

  Future<List<Map<String, dynamic>>> getPersonalCartProducts() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in.');

    final query = await _firestore
        .collection('carts')
        .where('userIds', arrayContains: user.uid)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return [];

    final data = query.docs.first.data();
    final productsMap = Map<String, int>.from(data['products'] ?? {});
    final ids = productsMap.keys.toList();

    // Load products using batched queries
    final products = await getProductsByIds(ids);

    return products.map((p) {
      return {
        "product": p,
        "quantity": productsMap[p.id] ?? 1,
      };
    }).toList();
  }


  /// Add product to cart

  Future<void> addProductToCart(
      String productId, BuildContext ctx, int requiredQuantity) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in.");

    final cartQuery = await _firestore
        .collection('carts')
        .where('userIds', arrayContains: user.uid)
        .limit(1)
        .get();

    // If no cart exists, create one
    if (cartQuery.docs.isEmpty) {
      final productSnap = await _firestore.collection('products').doc(productId).get();
      if (!productSnap.exists) throw Exception("Product not found.");

      final int available = productSnap.data()?['quantity'] ?? 0;
      if (available < requiredQuantity) throw Exception("Not enough stock!");

      await _firestore.collection('carts').add({
        'userIds': [user.uid],
        'products': {productId: requiredQuantity},
      });
      return;
    }

    final cartRef = cartQuery.docs.first.reference;

    // Transaction for safe update
    await _firestore.runTransaction((transaction) async {
      final cartSnap = await transaction.get(cartRef);
      final products = Map<String, dynamic>.from(cartSnap.data()?['products'] ?? {});

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
  }


  /// Decrease product quantity

  Future<void> decreaseProductQuantityCart(String productId) async {
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
      final products = Map<String, dynamic>.from(snapshot.data()?['products'] ?? {});

      if (products[productId] != null) {
        products[productId] = (products[productId] ?? 0) - 1;
        if (products[productId]! <= 0) products.remove(productId);
        transaction.update(cartRef, {'products': products});
      }
    });
  }

  /// Calculate totals 

  double calculateTotal(List<Map<String, dynamic>> items) {
    double initial = 0;
    double discounted = 0;

    for (var item in items) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      initial += product.price * quantity;
      discounted += product.price * quantity * (1 - product.discount / 100);
    }

    return discounted; // or return Map if needed
  }

  
  ///clear cart
  Future<void> clearCart(String userId) async {
    final cartRef = FirebaseFirestore.instance
        .collection("carts")
        .doc(userId)
        .collection("items");

    final items = await cartRef.get();
    for (var doc in items.docs) {
      await doc.reference.delete();
    }
  }


  /// Shared carts 

  Future<List<Map<String, dynamic>>> getSharedCarts() async {
    final query = await _firestore.collection('carts').get();
    if (query.docs.isEmpty) return [];

    final Map<String, int> allProductsMap = {};
    final Set<String> allUserIds = {};

    for (final doc in query.docs) {
      final data = doc.data();
      final productsData = data['products'] as Map<String, dynamic>? ?? {};
      final userIds = List<String>.from(data['userIds'] ?? []);
      allUserIds.addAll(userIds);

      for (final entry in productsData.entries) {
        allProductsMap[entry.key] = (allProductsMap[entry.key] ?? 0) +
            (entry.value as num?)!.toInt() ;
      }
    }

    final productsList = <Map<String, dynamic>>[];
    final productIds = allProductsMap.keys.toList();
    final products = await getProductsByIds(productIds);

    for (final product in products) {
      final quantity = allProductsMap[product.id] ?? 1;
      productsList.add({'product': product, 'quantity': quantity});
    }

    return [
      {'products': productsList, 'userIds': allUserIds.toList()},
    ];
  }
}
