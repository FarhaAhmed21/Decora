import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SpecialCard extends StatefulWidget {
  const SpecialCard({super.key});

  @override
  State<SpecialCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<SpecialCard> {
  bool isFavourite = false;
  bool isDiscount = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.cardColor,
      child: Container(

        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: AppColors.productCardColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      Assets.luxeSofa,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if(isDiscount)
                  Positioned(

                    left: 10,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                        margin: const EdgeInsets.all(10),

                        alignment: Alignment.center,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.orange
                        ),
                        child: Text( AppLocalizations.of(
                          context,
                        )!.discount,style: const TextStyle(fontSize: 12,color:AppColors.innerCardColor,fontWeight: FontWeight.bold,))

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
            const SizedBox(height: 10),

            // Title
            const Text(
              "Olive Luxe Sofa",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.mainText,
              ),
            ),

            const SizedBox(height: 6),

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
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.mainText,
                  ),
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(
                        context,
                      )!.explore,style: const TextStyle(fontSize: 14,color:AppColors.primary,)),
                      const Icon(Icons.arrow_forward,color: AppColors.primary, size: 14,),
                    ],
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
