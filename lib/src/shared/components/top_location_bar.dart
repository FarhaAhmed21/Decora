import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/notifications/screens/notifications_screen.dart';
import 'package:decora/src/features/notifications/services/notifications_services.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopLocationBar extends StatefulWidget {
  const TopLocationBar({super.key});

  @override
  State<TopLocationBar> createState() => _TopLocationBarState();
}

class _TopLocationBarState extends State<TopLocationBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final NotificationService _notificationService = NotificationService();
    final userId = AuthService().currentUser?.uid;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.009),
      child: SizedBox(
        height: height * 0.04,
        child: ListTile(
          title: Text(
            AppLocalizations.of(context)!.location,
            style: TextStyle(
              color: AppColors.secondaryText(),
              fontWeight: FontWeight.w400,
              fontSize: width * 0.035,
            ),
          ),
          subtitle: Row(
            children: [
              Image.asset(
                Assets.locationIcon,
                width: width * 0.045,
                height: width * 0.045,
                color: AppTheme.isDarkMode ? Colors.white : Colors.black,
              ),
              SizedBox(width: width * 0.015),
              Text(
                AppLocalizations.of(context)!.cairoEgypt,
                style: TextStyle(
                  color: AppColors.mainText(),
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.04,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(width * 0.03),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(width * 0.001),
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor(),
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Image.asset(
                    Assets.settingsIcon,
                    color: AppTheme.isDarkMode ? Colors.white : Colors.black,
                    width: width * 0.025,
                  ),
                ),
              ),
              SizedBox(width: width * 0.009),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                      setState(
                        () {},
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(width * 0.001),
                      width: width * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor(),
                        borderRadius: BorderRadius.circular(width * 0.05),
                      ),
                      child: Image.asset(
                        Assets.notificationIcon,
                        color: AppTheme.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        width: width * 0.025,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: -5,
                    child: FutureBuilder<int>(
                      future: userId == null
                          ? Future.value(0)
                          : _notificationService.getUnreadNotificationsCount(
                              userId,
                            ),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        if (count == 0) return const SizedBox.shrink();

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
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
