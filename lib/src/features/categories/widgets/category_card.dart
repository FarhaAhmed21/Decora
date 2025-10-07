import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.img,
    required this.onTap,
  });
  final String title;
  final String img;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          Container(
            width: 186,
            height: 157,
            decoration: ShapeDecoration(
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.mainText,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
