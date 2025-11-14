// test/helpers/test_helpers.dart
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserModel extends Mock implements UserModel {}

UserModel createTestUser({
  String id = 'test-123',
  String name = 'Test User',
  String email = 'test@example.com',
  String photoUrl = 'https://example.com/photo.jpg',
}) {
  return UserModel(id: id, name: name, email: email, photoUrl: photoUrl);
}
