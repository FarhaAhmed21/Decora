import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/models/address_model.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:decora/src/features/notifications/screens/notifications_screen.dart';
import 'package:decora/src/features/notifications/services/notifications_services.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:decora/core/l10n/local_cubit.dart';

class TopLocationBar extends StatefulWidget {
  const TopLocationBar({super.key});

  @override
  State<TopLocationBar> createState() => _TopLocationBarState();
}

class _TopLocationBarState extends State<TopLocationBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();

    final isDark = themeProvider.isDarkMode;

    final localeCubit = context.read<LocaleCubit>();
    final currentLocale = context.watch<LocaleCubit>().state;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final NotificationService notificationService = NotificationService();
    final userId = AuthService().currentUser?.uid;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.009),
      child: SizedBox(
        height: height * 0.06,
        child: ListTile(
          title: Text(
            AppLocalizations.of(context)!.location,
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontWeight: FontWeight.w400,
              fontSize: width * 0.035,
            ),
          ),
          subtitle: FutureBuilder<List<AddressModel>>(
            future: FirestoreService().getUserAddresses(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Row(
                  children: [
                    Icon(Icons.location_on, size: width * 0.045),
                    SizedBox(width: width * 0.015),
                    const Text("Loading..."),
                  ],
                );
              }

              final addresses = snapshot.data!;
              if (addresses.isEmpty) {
                return Row(
                  children: [
                    Icon(Icons.location_on, size: width * 0.045),
                    SizedBox(width: width * 0.015),
                    const Text("No Address Found"),
                  ],
                );
              }

              // Get default or first address
              final defaultAddress = addresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => addresses[0],
              );

              return Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: width * 0.045,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: width * 0.015),
                  Text(
                    "${defaultAddress.city}, ${defaultAddress.street}",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              );
            },
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Settings & Theme/Language
              InkWell(
                borderRadius: BorderRadius.circular(width * 0.03),
                onTap: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Dark Mode"),
                            Switch(
                              value: isDark,
                              onChanged: (val) {
                                themeProvider.toggleTheme();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Language"),
                            DropdownButton<Locale>(
                              value: currentLocale,
                              items: const [
                                DropdownMenuItem(
                                  value: Locale('en'),
                                  child: Text("English"),
                                ),
                                DropdownMenuItem(
                                  value: Locale('ar'),
                                  child: Text("Arabic"),
                                ),
                              ],
                              onChanged: (locale) {
                                if (locale != null) {
                                  localeCubit.setLocale(locale);
                                  Navigator.pop(context);
                                }
                              },
                              underline: const SizedBox(),
                              icon: const SizedBox.shrink(),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  width: width * 0.1,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: isDark ? Colors.white : Colors.black,
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
                      setState(() {});
                    },
                    child: Container(
                      width: width * 0.1,
                      height: width * 0.1,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(width * 0.05),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: -5,
                    child: FutureBuilder<int>(
                      future: userId == null
                          ? Future.value(0)
                          : notificationService.getUnreadNotificationsCount(),
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
