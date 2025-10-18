import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/profile/models/usermodel.dart';

class UserFirebase {
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('Users');

  Future<void> createUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final querySnapshot = await _usersCollection
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('❗ User with UID $uid not found in Firestore.');
        return null;
      }
    } catch (e) {
      print('🔥 Error fetching user: $e');
      return null;
    }
  }
}
