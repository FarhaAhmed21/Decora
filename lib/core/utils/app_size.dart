import 'package:flutter/material.dart';

class AppSize {
  // Base design reference (e.g., iPhone 12 screen)
  static const baseWidth = 390.0;
  static const baseHeight = 844.0;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}
