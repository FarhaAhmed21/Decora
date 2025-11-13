import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ✅ مزود الثيم
class AppThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // 🌞 الثيم الفاتح
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightMainText),
    ),
  );

  // 🌙 الثيم الداكن
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkMainText),
    ),
  );
}

/// 🎨 ألوان التطبيق
class AppColors {
  AppColors._();

  // =========================
  // Light mode colors
  // =========================
  static const Color lightCardColor = Color(0xFFF6F6F6);
  static const Color lightPrimary = Color(0xFF446F4D);
  static const Color lightMainText = Color(0xFF1A1A1A);
  static const Color lightSecondaryText = Color(0xFF7C7B7B);
  static const Color lightOrange = Color(0xFFEB9136);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightInnerCardColor = Color(0xFFF6F6F6);
  static const Color lightProductCardColor = Color(0xFFE6F3EF);
  static const Color lightTextColor = Color(0xFF2F3743);
  static const Color lightOrderIconUnSelectedColor = Color(0xFF7B879B);
  static const Color lightShoppingIconColor = Color.fromRGBO(
    195,
    255,
    208,
    0.37,
  );
  static const Color lightInnerProductCardBorder = Color.fromARGB(
    76,
    68,
    111,
    77,
  );
  static const Color lightInnerProductCardTypeText = Color(0xFF446F4D);

  // =========================
  // Dark mode colors
  // =========================
  static const Color darkCardColor = Color(0xFF313131);
  static const Color darkMainText = Color(0xFFE0E0E0);
  static const Color darkSecondaryText = Color(0xFFDADADA);
  static const Color darkBackground = Color(0xFF222222);
  static const Color darkInnerCardColor = Color(0xFF2C2C2C);
  static const Color darkProductCardColor = Color(0xFF363836);
  static const Color darkTextColor = Color(0xFFEEEEEE);
  static const Color darkOrderIconUnSelectedColor = Color(0xFF888888);
  static const Color darkShoppingIconColor = Color(0xFF2E7D32);
  static const Color darkInnerProductCardBorder = Color(0xFF4C9C4C);
  static const Color darkInnerProductCardTypeText = Color(0xFF80C080);

  // =========================
  // دوال ذكية تبع الوضع الحالي
  // =========================

  static bool _isDark(BuildContext context) =>
      Provider.of<AppThemeProvider>(context, listen: false).isDarkMode;

  static Color cardColor(BuildContext context) =>
      _isDark(context) ? darkCardColor : lightCardColor;

  static Color primary(BuildContext context) => lightPrimary;

  static Color mainText(BuildContext context) =>
      _isDark(context) ? darkMainText : lightMainText;

  static Color secondaryText(BuildContext context) =>
      _isDark(context) ? darkSecondaryText : lightSecondaryText;

  static Color orange(BuildContext context) => lightOrange;

  static Color background(BuildContext context) =>
      _isDark(context) ? darkBackground : lightBackground;

  static Color innerCardColor(BuildContext context) =>
      _isDark(context) ? darkInnerCardColor : lightInnerCardColor;

  static Color productCardColor(BuildContext context) =>
      _isDark(context) ? darkProductCardColor : lightProductCardColor;

  static Color textColor(BuildContext context) =>
      _isDark(context) ? darkTextColor : lightTextColor;

  static Color orderIconUnSelectedColor(BuildContext context) =>
      _isDark(context)
      ? darkOrderIconUnSelectedColor
      : lightOrderIconUnSelectedColor;

  static Color shoppingIconColor(BuildContext context, {double opacity = 1.0}) {
    final color = _isDark(context)
        ? darkMainText
        : lightShoppingIconColor;
    return color.withOpacity(opacity);
  }

  static Color innerProductCardBorder(BuildContext context) => _isDark(context)
      ? darkInnerProductCardBorder
      : lightInnerProductCardBorder;

  static Color innerProductCardTypeText(BuildContext context) =>
      _isDark(context)
      ? darkInnerProductCardTypeText
      : lightInnerProductCardTypeText;
}
