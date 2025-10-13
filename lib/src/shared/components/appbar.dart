import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: AppColors.background(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8.89),
                decoration: BoxDecoration(
                  color: AppColors.cardColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppTheme.isDarkMode ? Colors.white : Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: AppTheme.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  fontFamily: 'Montserratt',
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
