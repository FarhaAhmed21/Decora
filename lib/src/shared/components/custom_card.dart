import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/favourites/services/fav_service.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomCard extends StatefulWidget {
  final Product product;

  const CustomCard({super.key, required this.product});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((
      doc,
    ) {
      if (doc.exists && doc.data()!.containsKey('favourites')) {
        setState(() {
          isFavourite = (doc['favourites'] as List).contains(widget.product.id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final product = widget.product;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.02),
      ),
      color: AppColors.cardColor(),
      child: Container(
        width: w * 0.20,
        padding: EdgeInsets.all(w * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.02),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Product Image
                Container(
                  width: double.infinity,
                  height: h * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    color: AppColors.productCardColor(),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    child: Image.network(
                      product.colors.isNotEmpty
                          ? product.colors.first.imageUrl
                          : 'https://safainv.sa/front/assets/images/default.jpg',
                      height: h * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: h * 0.18,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: h * 0.18,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: h * 0.07,
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
                    left: w * 0.02,
                    top: w * 0.02,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: AppColors.orange(),
                      ),
                      child: Text(
                        "${product.discount}%",
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
                  top: h * 0.015,
                  right: w * 0.020,
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
                    child: isFavourite
                        ? Image.asset(
                            Assets.heartIcon,
                            color: AppColors.primary(),
                            width: w * 0.05,
                            height: h * 0.018,
                          )
                        : Image.asset(
                            Assets.heartOutline,
                            color: AppColors.primary(),
                            width: w * 0.05,
                            height: h * 0.018,
                          ),
                  ),
                ),
              ],
            ),

            SizedBox(height: h * 0.008),

            // Product Title
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: w * 0.04,
                color: AppColors.mainText(),
              ),
            ),

            // Price + Cart button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price}",
                  style: TextStyle(
                    fontSize: w * 0.045,
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
                    width: w * 0.09,
                    height: h * 0.040,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary(),
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
