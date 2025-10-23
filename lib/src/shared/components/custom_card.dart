import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
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
    isFavourite = widget.product.isFavourite;
  }

  Future<void> toggleFavourite() async {
    try {
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({'isfavourite': !isFavourite});

      // Update local UI
      setState(() {
        isFavourite = !isFavourite;
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavourite
                ? AppLocalizations.of(context)!
                .product_added_to_favourite_successfully
                : "Removed from favourites",
          ),
          backgroundColor: AppColors.primary(),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print("Error updating favourite: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating favourite status"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    color: AppColors.productCardColor(),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(w * 0.02),
                    child: Image.network(
                      product.colors.isNotEmpty
                          ? product.colors.first.imageUrl
                          : 'https://via.placeholder.com/150',
                      height: h * 0.18,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Discount Badge
                if (product.discount > 0)
                  Positioned(
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
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
                  top: h * 0.015,
                  right: w * 0.020,
                  child: GestureDetector(
                    onTap: toggleFavourite,
                    child: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primary(),
                      size: w * 0.07,
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

            const SizedBox(height: 4),

            // Price
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
                          AppLocalizations.of(context)!
                              .product_added_to_Cart_successfully,
                        ),
                        backgroundColor: AppColors.primary(),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: w * 0.09,
                    height: h * 0.040,
                    decoration: BoxDecoration(
                      color: AppColors.primary(),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: const Icon(Icons.shopping_bag, color: Colors.white),
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
