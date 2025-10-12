import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String? offerPercentage;

  const CustomCard({super.key, this.offerPercentage});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final bool hasOffer =
        widget.offerPercentage != null && widget.offerPercentage!.isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.02),
      ),
      color: AppColors.cardColor,
      child: Container(
        width: 192,
        height: 276,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    color: AppColors.productCardColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Assets.luxeSofa,
                      height: h * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                if (hasOffer)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      alignment: Alignment.center,
                      width: 72,
                      height: 22,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.offerColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "${widget.offerPercentage} OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: h * 0.015,
                  right: w * 0.020,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                        if (isFavourite) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.product_added_to_favourite_successfully,
                              ),
                              backgroundColor: AppColors.primary,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      });
                    },
                    child: isFavourite
                        ? Image.asset(
                            Assets.heartIcon,
                            color: AppColors.primary,
                            width: w * 0.05,
                            height: h * 0.018,
                          )
                        : Image.asset(
                            Assets.heartOutline,
                            color: AppColors.primary,
                            width: w * 0.05,
                            height: h * 0.018,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.008),

            // Title
            Text(
              "Olive Luxe Sofa",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.mainText,
                fontFamily: 'Montserratt',
              ),
            ),

            Row(
              children: [
                Image.asset(Assets.starIcon, width: w * 0.04, height: w * 0.04),
                SizedBox(width: w * 0.015),
                Text(
                  "4.9",
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$250",
                  style: TextStyle(
                    fontSize: w * 0.045,
                    color: AppColors.mainText,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserratt',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.product_added_to_Cart_successfully,
                        ),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: w * 0.09,
                    height: h * 0.040,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: Image.asset(
                      Assets.shoppingBagIcon,
                      color: Colors.white,
                      width: w * 0.30,
                      height: h * 0.030,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
