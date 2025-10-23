import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

import '../product_details/models/product_model.dart';
import '../product_details/services/product_services.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> discountedProductsFuture;

  @override
  void initState() {
    super.initState();
    discountedProductsFuture = _productService.getDiscountedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isLandscape = w > h;

    return Scaffold(
      backgroundColor: AppColors.background(),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Decora Specials',
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
            const CustomSearchBar(),
            SizedBox(height: h * 0.015),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                child: FutureBuilder<List<Product>>(
                  future: discountedProductsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No discounted products found'));
                    }

                    final discountedProducts = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLandscape ? 4 : 2,
                        childAspectRatio:
                        isLandscape ? w / (h * 1.6) : w / (h / 1.48),
                        mainAxisSpacing: 0.010 * w,
                        crossAxisSpacing: 0.010 * w,
                      ),
                      itemCount: discountedProducts.length,
                      itemBuilder: (context, index) {
                        final product = discountedProducts[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          ),
                          child: CustomCard(product: discountedProducts[index],

                          ),
                        );
                      },
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
