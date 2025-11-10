import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/onboarding/screens/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen widget test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

    expect(find.byType(PageView), findsOneWidget);

    expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);

    expect(find.text("Find Your Perfect Style"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);
  });
}
