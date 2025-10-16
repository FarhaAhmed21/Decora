import 'package:flutter/material.dart';

class AppTheme {
  static bool isDarkMode = true;
}

class AppColors {
  AppColors._();

  // =========================
  // Light mode colors
  // =========================
  static const Color lightCardColor = Color.fromRGBO(246, 246, 246, 1);
  static const Color lightPrimary = Color.fromRGBO(68, 111, 77, 1);
  static const Color lightMainText = Color.fromRGBO(26, 26, 26, 1);
  static const Color lightSecondaryText = Color.fromRGBO(124, 123, 123, 1);
  static const Color lightOrange = Color.fromRGBO(235, 145, 54, 1);
  static const Color lightBackground = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightInnerCardColor = Color.fromRGBO(246, 246, 246, 1);
  static const Color lightProductCardColor = Color.fromRGBO(238, 243, 239, 1);
  static const Color lightTextColor = Color.fromARGB(255, 47, 55, 67);
  static const Color lightOrderIconUnSelectedColor = Color.fromRGBO(
    123,
    135,
    155,
    1,
  );
  static const Color _lightShoppingIconColor = Color.fromRGBO(
    195,
    255,
    208,
    0.37,
  );
  static const Color _lightInnerProductCardBorder = Color.fromARGB(
    76,
    68,
    111,
    77,
  );
  static const Color _lightInnerProductCardTypeText = Color.fromARGB(
    255,
    68,
    111,
    77,
  );

  // =========================
  // Dark mode colors
  // =========================
  static const Color _darkCardColor = Color(0xff313131);
  static const Color _darkMainText = Color(0xFFE0E0E0);
  static const Color _darkSecondaryText = Color(0xffDADADA);
  static const Color _darkBackground = Color(0xff222222);
  static const Color _darkInnerCardColor = Color(0xFF2C2C2C);
  static const Color _darkProductCardColor = Color(0xff363836);
  static const Color _darkTextColor = Color(0xFFEEEEEE);
  static const Color _darkOrderIconUnSelectedColor = Color(0xFF888888);
  static const Color _darkShoppingIconColor = Color(0xFF2E7D32);
  static const Color _darkInnerProductCardBorder = Color(0xFF4C9C4C);
  static const Color _darkInnerProductCardTypeText = Color(0xFF80C080);

  // =========================
  // Colors getters
  // =========================
  static Color cardColor() =>
      AppTheme.isDarkMode ? _darkCardColor : lightCardColor;
  static Color primary() => AppTheme.isDarkMode ? lightPrimary : lightPrimary;
  static Color mainText() =>
      AppTheme.isDarkMode ? _darkMainText : lightMainText;
  static Color secondaryText() =>
      AppTheme.isDarkMode ? _darkSecondaryText : lightSecondaryText;
  static Color orange() => AppTheme.isDarkMode ? lightOrange : lightOrange;
  static Color background() =>
      AppTheme.isDarkMode ? _darkBackground : lightBackground;
  static Color innerCardColor() =>
      AppTheme.isDarkMode ? _darkInnerCardColor : lightInnerCardColor;
  static Color productCardColor() =>
      AppTheme.isDarkMode ? _darkProductCardColor : lightProductCardColor;

  static Color textColor() =>
      AppTheme.isDarkMode ? _darkTextColor : lightTextColor;

  static Color orderIconUnSelectedColor() => AppTheme.isDarkMode
      ? _darkOrderIconUnSelectedColor
      : lightOrderIconUnSelectedColor;

  static Color shoppingIconColor({double opacity = 1.0}) {
    Color color = AppTheme.isDarkMode
        ? _darkShoppingIconColor
        : _lightShoppingIconColor;
    return color.withOpacity(opacity);
  }

  static Color innerProductCardBorder() => AppTheme.isDarkMode
      ? _darkInnerProductCardBorder
      : _lightInnerProductCardBorder;
  static Color innerProductCardTypeText() => AppTheme.isDarkMode
      ? _darkInnerProductCardTypeText
      : _lightInnerProductCardTypeText;
}
