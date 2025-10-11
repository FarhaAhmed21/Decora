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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: size.width * 0.04,
        children: [
          Container(
            width: size.width * 0.5,
            height: size.width * 0.38,
            decoration: ShapeDecoration(
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.04),
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mainText,
              fontWeight: FontWeight.w800,
              fontSize: size.width * 0.04,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
