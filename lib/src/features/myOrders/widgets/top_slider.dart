import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopSlider extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  const TopSlider({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Localizations.localeOf(context).languageCode == 'en'
            ? 0
            : AppSize.width(context) * 0.027,
        right: Localizations.localeOf(context).languageCode == 'en'
            ? AppSize.width(context) * 0.027
            : 0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary(context)
                : AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.mainText(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
