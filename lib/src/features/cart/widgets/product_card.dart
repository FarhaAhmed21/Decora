import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: AppSize.width(context) * 0.27,
                    height: AppSize.height(context) * 0.13,
                    color: AppColors.innerCardColor,
                    child: Image.asset(Assets.couchImage),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Rating
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Moss Accent Sofa",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black,
                              ),

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.star, size: 18, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            "4.9",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Categories
                      Wrap(
                        spacing: 6,
                        children: [
                          _buildTag(AppLocalizations.of(context)!.dining),
                          _buildTag(AppLocalizations.of(context)!.furniture),
                          _buildTag(AppLocalizations.of(context)!.wood),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price + Quantity Controls
                      Row(
                        children: [
                          const Text(
                            "\$240",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),

                          Row(
                            children: [
                              Container(
                                width: AppSize.height(context)*0.047,
                                height: AppSize.height(context)*0.047,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.remove),
                                  iconSize: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "1",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: AppSize.height(context)*0.047,
                                height: AppSize.height(context)*0.047,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  iconSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,

        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.green,
        ),
      ),
    );
  }
}
