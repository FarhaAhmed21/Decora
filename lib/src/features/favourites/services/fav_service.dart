import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavService {
  Future<List<Product>> getFavs() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return [];

    final data = userDoc.data();
    final favourites = List<String>.from(data?['favourites'] ?? []);

    if (favourites.isEmpty) return [];

    List<Product> allFavProducts = [];

    // نقسم الليست كل 10 IDs
    for (int i = 0; i < favourites.length; i += 10) {
      final chunk = favourites.skip(i).take(10).toList();

      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      allFavProducts.addAll(
        snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)),
      );
    }

    return allFavProducts;
  }

  void addfavtolist(String id) {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    userDoc.update({
      'favourites': FieldValue.arrayUnion([id]),
    });
  }

  void deletefavfromlist(String id) {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    userDoc.update({
      'favourites': FieldValue.arrayRemove([id]),
    });
  }
}
