import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/favourites/services/fav_service.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../features/product_details/models/product_model.dart';

class CustomCard extends StatefulWidget {
  final Product product;

  const CustomCard({super.key, required this.product});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = false; // initial default

    User user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    userDoc.get().then((doc) {
      if (doc.exists && doc.data()!.containsKey('favourites')) {
        setState(() {
          isFavourite = (doc['favourites'] as List).contains(widget.product.id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final h = AppSize.height(context);
    // final w = AppSize.width(context);
    final product = widget.product;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final imageHeight = cardWidth * 0.8; // Responsive image height

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.cardColor(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Product Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.productCardColor(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.colors.isNotEmpty
                              ? product.colors.first.imageUrl
                              : 'https://via.placeholder.com/150',
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            // While image is loading, show a placeholder
                            return Container(
                              height: imageHeight,
                              width: double.infinity,
                              color: AppColors.productCardColor(),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // If image fails to load, show fallback placeholder
                            return Container(
                              height: imageHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.productCardColor(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image,
                                size: imageHeight * 0.4,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Discount Badge
                    if (product.discount > 0)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.orange(),
                          ),
                          child: Text(
                            '${product.discount}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.innerCardColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Favourite Icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                          if (isFavourite) {
                            FavService().addfavtolist(product.id);
                          } else {
                            FavService().deletefavfromlist(product.id);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavourite
                                    ? AppLocalizations.of(
                                        context,
                                      )!.product_added_to_favourite_successfully
                                    : "Removed from favourites",
                              ),
                              backgroundColor: AppColors.primary(),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary(),
                          size: cardWidth * 0.1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Product Title
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: cardWidth * 0.08,
                    color: AppColors.mainText(),
                  ),
                ),

                const SizedBox(height: 4),

                // Price + Cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: cardWidth * 0.08,
                        color: AppColors.mainText(),
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
                            backgroundColor: AppColors.primary(),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        width: cardWidth * 0.18,
                        height: cardWidth * 0.18,
                        decoration: BoxDecoration(
                          color: AppColors.primary(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
