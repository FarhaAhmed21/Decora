import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }
  Future<List<Product>> getDiscountedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('discount', isGreaterThan: 0)
        .get();

    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data(), doc.id);
    }).toList();
  }

}
