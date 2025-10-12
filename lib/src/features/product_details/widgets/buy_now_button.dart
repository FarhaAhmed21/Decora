
import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

class BuyNowButton extends StatelessWidget {
  const BuyNowButton({
    super.key,
    required this.h,
    required this.isLandscape,
    required this.w, required this.onpressed,
  });

  final double h;
  final bool isLandscape;
  final double w;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 34), // Adjusted padding to match screenshot's button width
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: h * 0.02) // Responsive vertical padding
            ),
            onPressed: onpressed,
            child: Text(
                "Buy Now",
                style: TextStyle(
                  fontSize: isLandscape ? w * 0.025 : 16, // Responsive font size
                  color:AppColors.cardColor,
                )
            )
        ),
      ),
    );
  }
}