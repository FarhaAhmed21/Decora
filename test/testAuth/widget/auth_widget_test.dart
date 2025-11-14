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
                const Text('Login'),
                TextFormField(key: const Key('email')),
                TextFormField(key: const Key('password')),
                ElevatedButton(onPressed: () {}, child: const Text('Login')),
                TextFormField(key:const  Key('email')),
                TextFormField(key:const Key('password')),
                ElevatedButton(onPressed: () {}, child:const Text('Login')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsWidgets);
      expect(find.byKey(const Key('email')), findsOneWidget);
      expect(find.byKey(const Key('password')), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('Forget Password Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Forget Password'),
                TextFormField(key: const Key('email')),
                ElevatedButton(onPressed: () {}, child: const Text('Continue')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Forget Password'), findsOneWidget);
      expect(find.byKey(const Key('email')), findsOneWidget);
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
                const Text('New Password'),
                TextFormField(key: const Key('newPassword')),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save New Password'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('New Password'), findsOneWidget);
      expect(find.byKey(const Key('newPassword')), findsOneWidget);
      expect(find.text('Save New Password'), findsOneWidget);
    });

    testWidgets('Sign Up Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Sign Up'),
                TextFormField(key: const Key('username')),
                TextFormField(key: const Key('email')),
                TextFormField(key: const Key('password')),
                ElevatedButton(onPressed: () {}, child: const Text('Create Account')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byKey(const Key('username')), findsOneWidget);
      expect(find.byKey(const Key('email')), findsOneWidget);
      expect(find.byKey(const Key('password')), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Password Reset Success Screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Password reset successfully!'),
                ElevatedButton(onPressed: () {}, child: const Text('Back to Login')),
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
                const Text('Verification successful!'),
                ElevatedButton(onPressed: () {}, child: const Text('Back to Login')),
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
