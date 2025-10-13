import 'package:flutter/material.dart';

import '../../../../core/utils/app_size.dart';
import '../../../shared/theme/app_colors.dart';

class AddCommentWidget extends StatelessWidget {
  const AddCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final w = AppSize.width(context);
    final h = AppSize.height(context); // Get height for better calculations
    final isLandscape = w > h;
    final iconSize = isLandscape ? w * 0.025 : 24.0;

    // Define the fixed height for the container
    final containerHeight = isLandscape ? w * 0.06 : 40.0;

    // Calculate vertical offset needed to center the text
    // A common fix is to apply a negative top padding or a small positive padding.
    // We'll calculate a small vertical padding to push it to the middle.
    // The exact value may require slight tweaking based on font metrics.
    final verticalPadding = isLandscape ? w * 0.005 : 5.0;

    // The horizontal padding for the entire row to align with the rest of the content
    const double paddingHorizontal = 8.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Expanded Text Field Container (White Background)
          Expanded(
            child: Container(
              height: containerHeight, // Use the defined height
              decoration: BoxDecoration(
                color: AppColors.cardColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                // Use Center to vertically align the entire TextField
                child: TextField(
                  // Use contentPadding to fine-tune vertical alignment
                  decoration: InputDecoration(
                    hintText: 'Write Your Review',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText(),
                      fontSize: isLandscape ? w * 0.018 : 16,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    // FIX: Apply minimal vertical content padding for centering.
                    contentPadding: EdgeInsets.symmetric(
                      vertical: -verticalPadding,
                    ),
                  ),
                  style: TextStyle(color: AppColors.mainText()),
                ),
              ),
            ),
          ),

          SizedBox(width: w * 0.03), // Space between input and icons
          // 2. Add Photo Icon (Image Asset) - Vertically centered by Row
          Image.asset(
            "assets/images/add_img.png",
            width: iconSize,
            height: iconSize,
          ),

          SizedBox(width: w * 0.02), // Space between icons
          // 3. Emoji Icon - Vertically centered by Row
          Icon(
            Icons.sentiment_satisfied_alt_outlined,
            color: AppColors.secondaryText(),
            size: iconSize,
          ),
        ],
      ),
    );
  }
}
