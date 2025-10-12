import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';

class NewCollections extends StatelessWidget {
  // Added an optional parameter to allow the parent (HomeScreen) to control horizontal padding
  final double horizontalPadding;

  const NewCollections({
    super.key,
    this.horizontalPadding = 16.0, // Default padding for stand-alone use
  });

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    // Responsive text sizes
    final titleSize = isLandscape ? w * 0.025 : 18.0;
    final subtitleSize = isLandscape ? w * 0.018 : 14.0;
    final buttonTextSize = isLandscape ? w * 0.018 : 14.0;

    // Responsive container height, reduced in landscape to fit more content
    final containerHeight = isLandscape ? h * 0.45 : h * 0.18;

    // Calculate dynamic button height
    final buttonHeight = isLandscape ? h * 0.05 : h * 0.045;


    return Padding(
      // Use the injected padding parameter
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: h * 0.01),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.cardColor,
          ),
          padding: EdgeInsets.all(isLandscape ? w * 0.015 : 16.0), // Responsive internal padding
          height: containerHeight,

          child :Row(
              children: [
                // 1. Text Content Column
                Expanded(
                  flex: 3, // Give text column slightly more space than image
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to push the button down
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Group text content together
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context,)!.new_collection,
                              style: TextStyle(
                                fontSize: titleSize,
                                color: AppColors.mainText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: h * 0.005), // Small space between title and subtitle

                            Text(
                              AppLocalizations.of(context,)!.elevate_your_living_room_with_timeless_sofas,
                              style: TextStyle(
                                fontSize: subtitleSize,
                                color: AppColors.secondaryText,
                              ),
                              maxLines: isLandscape ? 3 : 2, // Allow more lines in landscape
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        // Button
                        ElevatedButton(onPressed: (){},
                          style:  ButtonStyle(
                            backgroundColor:const WidgetStatePropertyAll<Color>(
                                AppColors.primary),
                            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            // Set minimum size using responsive values
                            minimumSize: WidgetStatePropertyAll<Size>(
                              Size(isLandscape ? w * 0.15 : 120, buttonHeight),
                            ),
                            shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                            ),

                          ),
                          child:  Text(
                            AppLocalizations.of(context,)!.explore,
                            style: TextStyle(
                              fontSize: buttonTextSize,
                              color:AppColors.cardColor,
                            ),
                          ),
                        )

                      ]
                  ),
                ),

                SizedBox(width: w * 0.03), // Separator between text and image

                // 2. Image Container
                Expanded(
                  flex: 2, // Give image slightly less space than text
                  child: Container(
                    height: double.infinity, // Fill the parent height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.productCardColor,
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        Assets.luxeSofa,
                        fit: BoxFit.cover, // Use BoxFit.cover to fill the space without distortion
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}