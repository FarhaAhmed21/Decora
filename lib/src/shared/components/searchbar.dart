import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppSize.height(context) * 0.04,
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Image.asset(Assets.searchIcon),
                  hintText: AppLocalizations.of(context)!.searchFurniture,
                  hintStyle: const TextStyle(color: AppColors.secondaryText),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 5),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8.89),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(Assets.filterIcon),
            ),
          ),
        ],
      ),
    );
  }
}
