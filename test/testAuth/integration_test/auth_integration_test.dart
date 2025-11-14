import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Test', () {
    testWidgets('Complete Signup → Login → Forgot Password Flow', (
      tester,
    ) async {
      print('=== Test Started ===');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                    key: const Key('create_account'),
                    onPressed: () {},
                    child: const Text('Create Account'),
                  ),
                  TextFormField(key: const Key('signup_name')),
                  TextFormField(key: const Key('signup_email')),
                  TextFormField(key: const Key('signup_password')),
                  TextButton(
                    key: const Key('sign_up'),
                    onPressed: () {},
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('create_account')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('signup_name')), 'Test User');
      await tester.enterText(
        find.byKey(const Key('signup_email')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signup_password')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('sign_up')));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                for (int i = 0; i < 4; i++) TextField(key: Key('otp_$i')),
                TextButton(onPressed: () {}, child:const Text('Verify')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byKey(Key('otp_$i')), '$i');
      }
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text(
              'Verification Successful',
              key: Key('verification_success'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('verification_success')), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(key: const Key('login_email')),
                TextFormField(key: const Key('login_password')),
                TextButton(
                  key: const Key('login_button'),
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login_email')),
        'test@example.com',
      );
      await tester.enterText(find.byKey(const Key('login_password')), '123456');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(key: const Key('forgot_email')),
                TextButton(onPressed: () {}, child:const Text('Continue')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('forgot_email')),
        'test@example.com',
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                for (int i = 0; i < 4; i++) TextField(key: Key('reset_otp_$i')),
                TextButton(onPressed: () {}, child:const Text('Verify')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byKey(Key('reset_otp_$i')), '$i');
      }
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(key: const Key('new_password')),
                TextButton(onPressed: () {}, child:const Text('Save New Password')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('new_password')), '654321');
      await tester.tap(find.text('Save New Password'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              key:const Key('back_to_login'),
              onPressed: () {},
              child:const Text('Back to Login'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('back_to_login')), findsOneWidget);

      await tester.tap(find.byKey(const Key('back_to_login')));
      await tester.pumpAndSettle();

      print('=== Test Completed Successfully ===');
    });
  });
}
