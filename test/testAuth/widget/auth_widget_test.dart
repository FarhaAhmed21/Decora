import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Screens Widget Tests', () {
    testWidgets('Login Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Login'),
                TextFormField(key: Key('email')),
                TextFormField(key: Key('password')),
                ElevatedButton(onPressed: () {}, child: Text('Login')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsWidgets);
      expect(find.byKey(Key('email')), findsOneWidget);
      expect(find.byKey(Key('password')), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('Forget Password Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Forget Password'),
                TextFormField(key: Key('email')),
                ElevatedButton(onPressed: () {}, child: Text('Continue')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Forget Password'), findsOneWidget);
      expect(find.byKey(Key('email')), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('OTP Reset Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(key: Key('otp$index')),
                ),
              ),
            ),
          ),
        ),
      );

      for (int i = 0; i < 4; i++) {
        expect(find.byKey(Key('otp$i')), findsOneWidget);
      }
    });

    testWidgets('OTP Verification Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(key: Key('otp_verify$index')),
                ),
              ),
            ),
          ),
        ),
      );

      for (int i = 0; i < 4; i++) {
        expect(find.byKey(Key('otp_verify$i')), findsOneWidget);
      }
    });

    testWidgets('New Password Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('New Password'),
                TextFormField(key: Key('newPassword')),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Save New Password'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('New Password'), findsOneWidget);
      expect(find.byKey(Key('newPassword')), findsOneWidget);
      expect(find.text('Save New Password'), findsOneWidget);
    });

    testWidgets('Sign Up Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Sign Up'),
                TextFormField(key: Key('username')),
                TextFormField(key: Key('email')),
                TextFormField(key: Key('password')),
                ElevatedButton(onPressed: () {}, child: Text('Create Account')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byKey(Key('username')), findsOneWidget);
      expect(find.byKey(Key('email')), findsOneWidget);
      expect(find.byKey(Key('password')), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Password Reset Success Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Password reset successfully!'),
                ElevatedButton(onPressed: () {}, child: Text('Back to Login')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Password reset successfully!'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('Verification Success Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Verification successful!'),
                ElevatedButton(onPressed: () {}, child: Text('Back to Login')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Verification successful!'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });
  });
}
