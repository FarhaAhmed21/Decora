import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/orderTracking/service/add_days.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatus extends StatelessWidget {
  final String date;
  final int oStatus;

  const OrderStatus({super.key, required this.date, this.oStatus = 0});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderStatusList = [
      {
        'title': "Order Placed",
        'date': date,
        'isCompleted': true,
        'iconPath': Assets.trackingIcon1,
      },
      {
        'title': "In Progress",
        'date': addDays(date, 2),
        'isCompleted': oStatus == 1 || oStatus == 2 || oStatus == 3,
        'iconPath': Assets.trackingIcon2,
      },
      {
        'title': "Shipped",
        'date': addDays(date, 4),
        'isCompleted': oStatus == 2 || oStatus == 3,
        'iconPath': Assets.trackingIcon3,
      },
      {
        'title': "Delivered",
        'date': addDays(date, 5),
        'isCompleted': oStatus == 3,
        'iconPath': Assets.trackingIcon4,
      },
    ];

    return Column(
      children: [
        for (int i = 0; i < orderStatusList.length; i++)
          OrderStatusIcons(
            title: orderStatusList[i]['title'],
            date: orderStatusList[i]['date'],
            isCompleted: orderStatusList[i]['isCompleted'],
            iconPath: orderStatusList[i]['iconPath'],
            nextIsCompleted: i < orderStatusList.length - 1
                ? orderStatusList[i + 1]['isCompleted']
                : false,
            previousIsCompleted: i > 0
                ? orderStatusList[i - 1]['isCompleted']
                : true,
          ),
      ],
    );
  }
}

class OrderStatusIcons extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final String iconPath;
  final bool nextIsCompleted;
  final bool previousIsCompleted;

  const OrderStatusIcons({
    super.key,
    required this.title,
    required this.date,
    this.isCompleted = false,
    required this.iconPath,
    this.nextIsCompleted = false,
    this.previousIsCompleted = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool showLine = iconPath != Assets.trackingIcon4;
    final bool shouldShowGradient =
        isCompleted && previousIsCompleted && !nextIsCompleted;

    return Stack(
      children: [
        if (showLine)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 35),
            child: Container(
              height: 60,
              width: 3,
              decoration: BoxDecoration(
                color: shouldShowGradient
                    ? null
                    : isCompleted
                    ? AppColors.primary(context)
                    : AppColors.orderIconUnSelectedColor(context),
                gradient: shouldShowGradient
                    ? LinearGradient(
                        colors: [
                          AppColors.primary(context),
                          AppColors.orderIconUnSelectedColor(context),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
              ),
            ),
          ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primary(context)
                    : AppColors.orderIconUnSelectedColor(context),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Image.asset(iconPath, scale: 1.45),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.mainText(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isCompleted ? date : "Unknown",
                  style: TextStyle(
                    color: AppColors.secondaryText(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Spacer(),
            Text(
              isCompleted ? "Completed" : "Pending",
              style: TextStyle(
                color: AppColors.secondaryText(context),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
