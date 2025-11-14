import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../features/product_details/models/product_model.dart';
import 'package:decora/src/features/favourites/services/fav_service.dart';

class SpecialCard extends StatefulWidget {
  final Product product;
  const SpecialCard({super.key, required this.product});

  @override
  State<SpecialCard> createState() => _SpecialCardState();
}

class _SpecialCardState extends State<SpecialCard> {
  late bool isFavourite;
  late bool isDiscount;

  @override
  void initState() {
    super.initState();
    isFavourite = false;
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
    isDiscount = widget.product.discount > 0;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return SizedBox(
      width: 180,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final imageHeight = cardWidth * 0.7;
          final fontScale = cardWidth * 0.065;

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.cardColor(context),
            child: Padding(
              padding: EdgeInsets.all(cardWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Product image
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.productCardColor(context),
                          borderRadius: BorderRadius.circular(12),
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
                              return Container(
                                height: imageHeight,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: imageHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.productCardColor(context),
                                  borderRadius: BorderRadius.circular(12),
                                ),
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

                      // Discount badge
                      if (isDiscount)
                        Positioned(
                          left: cardWidth * 0.03,
                          top: cardWidth * 0.03,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: cardWidth * 0.03,
                              vertical: cardWidth * 0.015,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.orange(context),
                            ),
                            child: Text(
                              " ${product.discount}${AppLocalizations.of(context)!.discount}",
                              style: TextStyle(
                                fontSize: fontScale * 0.8,
                                color: AppColors.innerCardColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Favourite icon
                      Positioned(
                        top: cardWidth * 0.03,
                        right: cardWidth * 0.03,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => isFavourite = !isFavourite);
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
                                backgroundColor: AppColors.primary(context),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Image.asset(
                            isFavourite
                                ? Assets.heartIcon
                                : Assets.heartOutline,
                            color: AppColors.primary(context),
                            width: cardWidth * 0.08,
                            height: cardWidth * 0.08,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: cardWidth * 0.03),

                  // Product name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: fontScale * 1.2,
                      color: AppColors.mainText(context),
                    ),
                  ),

                  SizedBox(height: cardWidth * 0.02),

                  // Rating

                  // Price & Explore button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontScale * 1.2,
                          color: AppColors.mainText(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to product details
                        },
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.explore,
                              style: TextStyle(
                                fontSize: fontScale,
                                color: AppColors.primary(context),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.primary(context),
                              size: fontScale,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
