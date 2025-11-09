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
      child: Container(
        constraints: const BoxConstraints(maxHeight: 130),
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0,
          color: AppColors.cardColor(context),
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
                    color: AppColors.productCardColor(context),
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
                          _buildTag(
                            AppLocalizations.of(context)!.dining,
                            context,
                          ),
                          _buildTag(
                            AppLocalizations.of(context)!.furniture,
                            context,
                          ),
                          _buildTag(
                            AppLocalizations.of(context)!.wood,
                            context,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

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
                                width: AppSize.height(context) * 0.04,
                                height: AppSize.height(context) * 0.04,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    138,
                                    207,
                                    207,
                                    207,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.remove),
                                  iconSize: 15,
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Text(
                                "1",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Container(
                                width: AppSize.height(context) * 0.04,
                                height: AppSize.height(context) * 0.04,
                                decoration: BoxDecoration(
                                  color: AppColors.primary(context),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  iconSize: 15,
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

  Widget _buildTag(String tag, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.innerProductCardBorder(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,

        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: AppColors.innerProductCardTypeText(context),
        ),
      ),
    );
  }
}
