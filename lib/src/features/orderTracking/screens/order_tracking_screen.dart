import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/orderTracking/widgets/bottom_green_button.dart';
import 'package:decora/src/features/orderTracking/widgets/order_status.dart';
import 'package:decora/src/features/orderTracking/widgets/order_tracking_product_container.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Tracking',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderTrackingProductContainer(
                      title: "Moss Accent Sofa",
                      subtitle: "Seater Sofa | Qty : 2",
                      price: "1120 EGP",
                      imagePath: Assets.couchImage,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Order Details",
                      style: TextStyle(
                        color: AppColors.mainText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          "Expected Delivery Date",
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "10 Dec 2024",
                          style: TextStyle(
                            color: AppColors.mainText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          "Order ID",
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "#GR47",
                          style: TextStyle(
                            color: AppColors.mainText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Order Status",
                      style: TextStyle(
                        color: AppColors.mainText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const OrderStatus(),
                  ],
                ),
              ),
            ),
            BottomGreenButton(onTap: () {}, buttonText: "Track Live Location"),
          ],
        ),
      ),
    );
  }
}
