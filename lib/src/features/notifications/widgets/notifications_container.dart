import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NoificationsContainer extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final int icon;
  const NoificationsContainer({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.icon = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary(),
            width: 1,
          ), // CHECK THIS: Looks pixely
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: icon == 0
                      ? AppColors.primary()
                      : AppColors.cardColor(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  "assets/icons/notification-icon.png",
                  color: icon == 0 ? Colors.white : AppColors.primary(),
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainText(),
                        fontSize:
                            15, // CHECK THIS: Check the font with the device
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 12,
                        color: AppColors.secondaryText(),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: AppColors.secondaryText(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
