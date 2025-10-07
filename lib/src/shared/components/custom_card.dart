import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.cardColor,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.productCardColor,
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      Assets.luxeSofa,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
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
                              // behavior:
                              //     SnackBarBehavior.floating,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(12),
                              // ),
                            ),
                          );
                        }
                      });
                    },
                    child: isFavourite
                        ? Image.asset(
                            Assets.heartIcon,
                            color: AppColors.primary,
                            width: 18,
                            height: 18,
                          )
                        : Image.asset(
                            Assets.heartOutline,
                            color: AppColors.primary,
                            width: 18,
                            height: 18,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            const Text(
              "Olive Luxe Sofa",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.mainText,
              ),
            ),

            //const SizedBox(height: 1),
            Row(
              children: [
                Image.asset(Assets.starIcon, width: 14, height: 14),
                const SizedBox(width: 4),
                const Text(
                  "4.9",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),

            //const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "\$250",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.mainText,
                    fontWeight: FontWeight.w500,
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
                        // behavior:
                        //     SnackBarBehavior.floating,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                      ),
                    );
                  },
                  child: Container(
                    width: 43,
                    height: 40,
                    padding: const EdgeInsets.all(11.03),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      Assets.shoppingBagIcon,
                      color: Colors.white,
                      width: 30,
                      height: 30,
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
