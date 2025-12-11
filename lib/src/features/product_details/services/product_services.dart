import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore;

  ProductService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Named constructor for tests
  factory ProductService.forTest(FirebaseFirestore fakeFirestore) {
    return ProductService(firestore: fakeFirestore);
  }

Future<void> reduceStockFromCart(String userId) async {
  final carts = await _firestore
      .collection('carts')
      .where('userIds', arrayContains: userId)
      .where('isShared', isEqualTo: false)
      .limit(1)
      .get();

  if (carts.docs.isEmpty) return;

  final cart = carts.docs.first;
  final Map<String, dynamic> products =
      Map<String, dynamic>.from(cart['products'] ?? {});

  WriteBatch batch = _firestore.batch();

  for (var entry in products.entries) {
    final String productId = entry.key;
    final int quantityBought = entry.value;

    final productRef = _firestore.collection('products').doc(productId);

    batch.update(productRef, {
      'quantity': FieldValue.increment(-quantityBought),
    });
  }

  batch.update(cart.reference, {'products': {}});
  await batch.commit();
}
  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    print("there is  ${snapshot.docs.length} products karen");

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Product>> getDiscountedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('discount', isGreaterThan: 0)
        .get();
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromMap(doc.data(), doc.id);
    }).toList();
    print("there are ${products.length} discounted products karen");

    return products;
  }

  Future<List<Product>> getNewCollectionProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('isNewCollection', isEqualTo: true)
        .get();
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromMap(doc.data(), doc.id);
    }).toList();
    print("there are ${products.length} of new collection products karen");

    return products;
  }

  Future<List<Comment>> fetchComments(Product product) async {
    final snapshot = await _firestore
        .collection('products')
        .doc(product.id)
        .get();
    print("product id: ${product.id}");

    if (snapshot.exists) {
      final data = snapshot.data()!;
      print("data keys: ${data.keys}");

      final rawComments = data['comments'];

      if (rawComments == null) {
        print("no comments field karen");
        return [];
      }

      try {
        final comments = (rawComments as List)
            .map((item) => Comment.fromMap(Map<String, dynamic>.from(item)))
            .toList();
        print("there are ${comments.length} comments karen");
        return comments;
      } catch (e) {
        print("error while parsing comments karen: $e");
        return [];
      }
    } else {
      print("no product found karen");
      return [];
    }
  }

  Future<void> addComment({
    required String productId,
    required Comment comment,
  }) async {
    try {
      final commentData = {
        'text': comment.text,
        'date': comment.date,
        'userid': comment.userid,
      };

      await _firestore.collection('products').doc(productId).update({
        'comments': FieldValue.arrayUnion([commentData]),
      });

      print("✅ Comment added successfully to product $productId");
    } catch (e) {
      print("❌ Error adding comment: $e");
    }
  }
}
