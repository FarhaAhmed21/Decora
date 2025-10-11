import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class OrderTrackingProductContainer extends StatelessWidget {
  String title;
  String subtitle;
  String price;
  String imagePath;
  OrderTrackingProductContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: AppSize.height(context) * 0.1 + 22,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: AppSize.height(context) * 0.1,
              width: AppSize.width(context) * 0.25,
              decoration: BoxDecoration(
                color: AppColors.productCardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 19,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
