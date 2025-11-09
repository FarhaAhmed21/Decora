import 'package:decora/src/features/notifications/screens/notifications_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:decora/core/l10n/local_cubit.dart';

class TopLocationBar extends StatelessWidget {
  const TopLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final localeCubit = context.read<LocaleCubit>();
    final currentLocale = context.watch<LocaleCubit>().state;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.009),
      child: SizedBox(
        height: height * 0.06,
        child: ListTile(
          title: Text(
            "Location",
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontWeight: FontWeight.w400,
              fontSize: width * 0.035,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.location_on,
                size: width * 0.045,
                color: isDark ? Colors.white : Colors.black,
              ),
              SizedBox(width: width * 0.015),
              Text(
                "Cairo, Egypt",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.04,
                ),
              ),
            ],
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
                    position: RelativeRect.fromLTRB(100, 80, 0, 0),
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
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
                    Icons.notifications,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
