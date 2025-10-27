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
