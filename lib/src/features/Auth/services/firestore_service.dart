import 'package:cloud_firestore/cloud_firestore.dart';
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
}
