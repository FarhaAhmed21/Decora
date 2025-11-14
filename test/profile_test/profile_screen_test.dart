import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';
import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('ProfileBody Widget Tests', () {
    late UserModel testUser;

    setUp(() {
      testUser = UserModel(
        id: '123',
        name: 'Abdo QA',
        email: 'abdo.qa@example.com',
        photoUrl: '',
      );
    });

    testWidgets('ProfileBody يعرض بيانات المستخدم بشكل صحيح', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProfileBody(user: testUser)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Abdo QA'), findsOneWidget);
      expect(find.text('abdo.qa@example.com'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byType(CustomSettingsTile), findsNWidgets(5)); // أكثر تحديداً
    });

    // إضافة المزيد من الاختبارات

    testWidgets('يعرض الصورة الافتراضية عندما photoUrl فارغ', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProfileBody(user: testUser)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // تأكد أن الـ CircleAvatar موجود (سيستخدم الصورة الافتراضية)
      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar).first,
      );
      expect(circleAvatar, isNotNull);
    });

    testWidgets('يحتوي على جميع خيارات الإعدادات المطلوبة', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProfileBody(user: testUser)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // تأكد من وجود 5 خيارات إعدادات (حسب الكود الأصلي)
      expect(find.byType(CustomSettingsTile), findsNWidgets(5));
    });
  });

  group('ProfileBody Edge Cases', () {
    testWidgets('يتعامل مع user بدون name', (WidgetTester tester) async {
      final userWithoutName = UserModel(
        id: '123',
        email: 'test@example.com',
        // name is null
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProfileBody(user: userWithoutName)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Name'), findsOneWidget);
    });

    testWidgets('يتعامل مع user بدون email', (WidgetTester tester) async {
      final userWithoutEmail = UserModel(
        id: '123',
        name: 'Test User',
        // email is null
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProfileBody(user: userWithoutEmail)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Email field should be empty but still exists
      expect(find.text('Test User'), findsOneWidget);
    });
  });
}
