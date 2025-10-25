import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:decora/src/shared/components/custom_card.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/top_location_bar.dart';
import 'package:flutter/material.dart';
import '../../product_details/models/product_model.dart';

class FavouriteScreen extends StatelessWidget {
  final List<Product> favProducts;

  const FavouriteScreen({super.key, required this.favProducts});

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopLocationBar(),
            SizedBox(height: h * 0.055),
            const CustomSearchBar(),
            SizedBox(height: h * 0.015),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                child: GridView.builder(
                  itemCount: favProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 4 : 2,
                    childAspectRatio: isLandscape ? 1.3 : 0.75,
                    mainAxisSpacing: 0.010 * w,
                    crossAxisSpacing: 0.010 * w,
                  ),
                  itemBuilder: (context, index) {
                    final product = favProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: product),
                        ),
                      ),
                      child: CustomCard(product: product),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
