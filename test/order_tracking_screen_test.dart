import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:decora/src/features/orderTracking/screens/order_tracking_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/home/main_screen.dart'; // for AppThemeProvider

void main() {
  const testOrderId = 'DO123';

  Widget buildScreen() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider(
        create: (_) => AppThemeProvider(),
        child: Scaffold(
          body: OrderTrackingScreen(orderId: testOrderId, iconStatus: 'Shipped'),
        ),
      ),
    );
  }

  testWidgets('shows loading initially', (tester) async {
    // No orders added → service will wait → show loading
    await tester.pumpWidget(buildScreen());

    // Should show CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows "Order not found" when no order exists', (tester) async {
    // No orders added
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Order not found'), findsOneWidget);
  });

  testWidgets('shows product loading', (tester) async {
    // This test is purely about showing the loading indicator
    await tester.pumpWidget(buildScreen());

    // Loading indicator for products
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
