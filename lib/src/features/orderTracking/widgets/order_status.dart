import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatus extends StatelessWidget {
  const OrderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderStatusList = [
      {
        'title': "Order Placed",
        'date': "28 Jul, 2025",
        'isCompleted': true,
        'iconPath': Assets.trackingIcon1,
      },
      {
        'title': "In Progress",
        'date': "28 Jul, 2025",
        'isCompleted': true,
        'iconPath': Assets.trackingIcon2,
      },
      {
        'title': "Shipped",
        'date': "28 Jul, 2025",
        'isCompleted': true,
        'iconPath': Assets.trackingIcon3,
      },
      {
        'title': "Delivered",
        'date': "28 Jul, 2025",
        'isCompleted': false,
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
                    ? AppColors.primary()
                    : AppColors.orderIconUnSelectedColor(),
                gradient: shouldShowGradient
                    ? LinearGradient(
                        colors: [
                          AppColors.primary(),
                          AppColors.orderIconUnSelectedColor(),
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
                    ? AppColors.primary()
                    : AppColors.orderIconUnSelectedColor(),
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
                    color: AppColors.mainText(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isCompleted ? date : "Unknown",
                  style: TextStyle(
                    color: AppColors.secondaryText(),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Spacer(),
            Text(
              isCompleted ? "Completed" : "Pending",
              style: TextStyle(color: AppColors.secondaryText(), fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
