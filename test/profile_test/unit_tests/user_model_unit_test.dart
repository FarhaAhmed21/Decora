// test/features/auth/models/user_model_unit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';

void main() {
  group('UserModel Unit Tests', () {
    test('should create user with required fields only', () {
      // Act
      final user = UserModel(id: 'test-1');

      // Assert
      expect(user.id, 'test-1');
      expect(user.name, isNull);
      expect(user.email, isNull);
      expect(user.favourites, isEmpty);
    });

    test('toMap should include all fields', () {
      // Arrange
      final user = UserModel(
        id: '123',
        name: 'John',
        email: 'john@test.com',
        photoUrl: 'photo.jpg',
        favourites: ['item1', 'item2'],
      );

      // Act
      final map = user.toMap();

      // Assert
      expect(map['id'], '123');
      expect(map['name'], 'John');
      expect(map['email'], 'john@test.com');
      expect(map['photoUrl'], 'photo.jpg');
      expect(map['favourites'], ['item1', 'item2']);
    });

    test('fromMap should handle empty data', () {
      // Arrange
      final map = {'id': 'test-id'};

      // Act
      final user = UserModel.fromMap(map);

      // Assert
      expect(user.id, 'test-id');
      expect(user.name, isNull);
      expect(user.addresses, isEmpty);
      expect(user.favourites, isEmpty);
    });

    test('favourites should be empty list by default', () {
      // Act
      final user = UserModel(id: 'test');

      // Assert
      expect(user.favourites, isNotNull);
      expect(user.favourites, isEmpty);
    });
  });
}
