import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/Auth/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';



class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String userCollection = 'users';

  Future<void> saveUserData(UserModel user) async {
    final userRef = _firestore.collection(userCollection).doc(user.id);
    await userRef.set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> markPasswordChanged(String uid) async {
    await _firestore.collection(userCollection).doc(uid).update({
      'lastPasswordChange': FieldValue.serverTimestamp(),
    });
  }



  Future<List<AddressModel>> getUserAddresses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) return [];

    final data = doc.data()!;
    final addresses = data['addresses'] as List<dynamic>? ?? [];

    return addresses.map((e) => AddressModel.fromMap(e)).toList();
  }


  //get user data
  Future<UserModel> getUserData(String uid) async {
    final userRef = _firestore.collection(userCollection).doc(uid);
    final doc = await userRef.get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    } else {
      throw Exception('User not found');
    }
  }
}
