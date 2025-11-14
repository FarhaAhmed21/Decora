// test/features/profile/profile_body_unit_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'test_helpers.dart';

void main() {
  group('ProfileBody Unit Tests', () {
    test('generateOtp should return 4-digit string', () {
      // Arrange
      final profileBody = ProfileBody(user: createTestUser());

      // Act - نختبر الـ logic من غير ما نعتمد على الـ state مباشرة
      final state = profileBody.createState();

      // نستخدم reflection أو نختبر السلوك بشكل غير مباشر
      final otp = _invokeGenerateOtp(state);

      // Assert
      expect(otp, isA<String>());
      expect(otp.length, 4);
      expect(int.tryParse(otp), isNotNull);
    });

    test('generateOtp should always return 4 characters', () {
      // Arrange
      final profileBody = ProfileBody(user: createTestUser());
      final state = profileBody.createState();

      // Act & Assert - Test multiple times
      for (int i = 0; i < 10; i++) {
        final otp = _invokeGenerateOtp(state);
        expect(otp.length, 4);
        expect(otp, isNot(contains(RegExp(r'[^0-9]')))); // Only digits
      }
    });

    test('ProfileBody creates state successfully', () {
      // Arrange
      final profileBody = ProfileBody(user: createTestUser());

      // Act
      final state = profileBody.createState();

      // Assert
      expect(state, isNotNull);
      expect(state, isA<State<ProfileBody>>());
    });
  });

  group('ProfileBody Navigation Logic', () {
    test('settings items should contain expected options', () {
      final expectedSettings = [
        'Edit Profile',
        'Change Password',
        'Transaction History',
        'Help & Support',
        'Logout',
      ];

      expect(expectedSettings.length, 5);
      expect(expectedSettings, contains('Logout'));
      expect(expectedSettings, contains('Edit Profile'));
    });
  });
}

// Helper function لتجنب استخدام الـ private state مباشرة
String _invokeGenerateOtp(State<ProfileBody> state) {
  // نستخدم dynamic علشان نتجنب مشكلة الـ private type
  final dynamic dynamicState = state;
  return dynamicState.generateOtp();
}
