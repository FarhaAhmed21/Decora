import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FavService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : auth = auth ?? FirebaseAuth.instance,
      firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Product>> getFavs() async {
    final user = auth.currentUser!;
    final userDoc = await firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return [];

    final data = userDoc.data();
    final favourites = List<String>.from(data?['favourites'] ?? []);

    if (favourites.isEmpty) return [];

    List<Product> allFavProducts = [];

    for (int i = 0; i < favourites.length; i += 10) {
      final chunk = favourites.skip(i).take(10).toList();

      final snapshot = await firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      allFavProducts.addAll(
        snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)),
      );
    }

    return allFavProducts;
  }

  Future<void> addfavtolist(String id) async {
    final user = auth.currentUser!;
    final userDoc = firestore.collection('users').doc(user.uid);
    await userDoc.update({
      'favourites': FieldValue.arrayUnion([id]),
    });
  }

  Future<void> deletefavfromlist(String id) async {
    final user = auth.currentUser!;
    final userDoc = firestore.collection('users').doc(user.uid);
    await userDoc.update({
      'favourites': FieldValue.arrayRemove([id]),
    });
  }
}
