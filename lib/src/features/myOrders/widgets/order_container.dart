import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderContainer extends StatelessWidget {
  final String orderId;
  final String orderDate;
  final String orderAmount;
  final String orderStatus;
  const OrderContainer({
    super.key,
    this.orderId = 'XXXXX',
    this.orderDate = 'XX XXX, 20XX',
    this.orderAmount = 'XXXX',
    this.orderStatus = 'XXXXX',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Order ID #$orderId',
                  style: TextStyle(
                    color: AppColors.mainText(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  '$orderAmount EGP',
                  style: TextStyle(
                    color: AppColors.mainText(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  orderDate,
                  style: TextStyle(
                    color: AppColors.secondaryText(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  height: 26.5,
                  width: 97,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.shoppingIconColor(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.trackingIcon3,
                        color: AppColors.primary(context),
                        height: 14,
                      ),
                      Text(
                        orderStatus,
                        style: TextStyle(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "Details  ",
                  style: TextStyle(
                    color: AppColors.primary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(Assets.sideArrowIcon, height: 11.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
