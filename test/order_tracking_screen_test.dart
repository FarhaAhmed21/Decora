import 'dart:async';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/myOrders/service/order_service.dart';
import 'package:decora/src/features/orderTracking/screens/order_tracking_screen.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  final testOrderId = 'DO123';
  final today = DateFormat('dd MMM, yyyy').format(DateTime.now());

  setUp(() {
    mainProductsFuture = Completer<List<Product>>().future;
    OrderService.testGetOrderByIdOverride = null;
  });

  Widget buildScreen({
    required String iconStatus,
    Future<Map<String, dynamic>?>? orderFuture,
    Future<List<Product>>? productsFuture,
  }) {
    if (orderFuture != null) {
      OrderService.testGetOrderByIdOverride = (_) => orderFuture;
    }
    if (productsFuture != null) {
      mainProductsFuture = productsFuture;
    }

    final themeProvider = AppThemeProvider();
    themeProvider.toggleTheme();

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: ChangeNotifierProvider.value(
        value: themeProvider,
        child: Scaffold(
          body: OrderTrackingScreen(
            orderId: testOrderId,
            iconStatus: iconStatus,
          ),
        ),
      ),
    );
  }

  group('OrderTrackingScreen - Pure Logic Only', () {
    testWidgets('shows loading', (tester) async {
      final c = Completer<Map<String, dynamic>?>();
      OrderService.testGetOrderByIdOverride = (_) => c.future;

      await tester.pumpWidget(buildScreen(iconStatus: 'Shipped'));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      c.complete(null);
      await tester.pumpAndSettle();
    });

    testWidgets('shows "Order not found"', (tester) async {
      OrderService.testGetOrderByIdOverride = (_) async => null;

      await tester.pumpWidget(buildScreen(iconStatus: 'Shipped'));
      await tester.pumpAndSettle();

      expect(find.text('Order not found'), findsOneWidget);
    });

    testWidgets('shows product loading', (tester) async {
      OrderService.testGetOrderByIdOverride = (_) async => {
        'date': today,
        'productsId': ['P1'],
      };

      final pc = Completer<List<Product>>();
      mainProductsFuture = pc.future;

      await tester.pumpWidget(buildScreen(iconStatus: 'Shipped'));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pc.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('shows "No products found"', (tester) async {
      OrderService.testGetOrderByIdOverride = (_) async => {
        'date': today,
        'productsId': ['P1'],
      };

      mainProductsFuture = Future.value(<Product>[]);

      await tester.pumpWidget(buildScreen(iconStatus: 'Shipped'));
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
    });
  });
}
