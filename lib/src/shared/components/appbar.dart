import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.mainText,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 36,
              width: 36,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.mainText,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
