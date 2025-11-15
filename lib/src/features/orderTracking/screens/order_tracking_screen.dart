import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/myOrders/service/order_service.dart';
import 'package:decora/src/features/orderTracking/service/add_days.dart';
import 'package:decora/src/features/orderTracking/widgets/order_status.dart';
import 'package:decora/src/features/orderTracking/widgets/order_tracking_product_container.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final String iconStatus;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.iconStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: OrderService.getOrderById(orderId),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!orderSnapshot.hasData || orderSnapshot.data!.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.orderNotFound),
            );
          }

          final order = orderSnapshot.data!;
          final List<String> productsIds = List<String>.from(
            order['productsId'] ?? [],
          );

          return FutureBuilder<List<Product>>(
            future: mainProductsFuture,
            builder: (context, productsSnapshot) {
              if (productsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!productsSnapshot.hasData || productsSnapshot.data!.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noProductsFound),
                );
              }

              final orderProducts = productsSnapshot.data!
                  .where((p) => productsIds.contains(p.id))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 5),
                  CustomAppBar(
                    title: AppLocalizations.of(context)!.orderTracking,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final product in orderProducts)
                              OrderTrackingProductContainer(
                                title: product.name,
                                subtitle: product.category,
                                price: "\$${product.price}",
                                imagePath: product.colors[0].imageUrl,
                              ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.orderDetails,
                              style: TextStyle(
                                color: AppColors.mainText(context),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.expectedDeliveryDate,
                                  style: TextStyle(
                                    color: AppColors.secondaryText(context),
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  addDays(order['date'], 5) ?? "N/A",
                                  style: TextStyle(
                                    color: AppColors.mainText(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.orderID,
                                  style: TextStyle(
                                    color: AppColors.secondaryText(context),
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "#$orderId",
                                  style: TextStyle(
                                    color: AppColors.mainText(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Text(
                              AppLocalizations.of(context)!.orderStatus,
                              style: TextStyle(
                                color: AppColors.mainText(context),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            OrderStatus(
                              date: order['date'],
                              oStatus:
                                  order['date'] ==
                                      DateFormat(
                                        'dd MMM, yyyy',
                                      ).format(DateTime.now())
                                  ? 0
                                  : iconStatus == "Delivered"
                                  ? 3
                                  : iconStatus == "Shipped"
                                  ? 2
                                  : 1,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
