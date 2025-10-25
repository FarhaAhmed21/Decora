import 'package:decora/src/features/categories/screens/categories_screen.dart';
import 'package:decora/src/features/offers/offers_screen.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
// NOTE: Assuming this service has methods to fetch different lists of products
import 'package:decora/src/features/product_details/services/product_services.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../shared/components/custom_card.dart';
import '../../../shared/components/searchbar.dart';
import '../../../shared/components/special_card.dart';
import '../../../shared/components/top_location_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/list_of_categores.dart';
import '../widgets/new_collections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  // Future for the horizontal "Decora Specials" list (e.g., offers/featured)
  late Future<List<Product>> _specialsFuture;

  // Future for the main product grid
  late Future<List<Product>> _mainProductsFuture;

  @override
  void initState() {
    super.initState();
    // Assuming getSpecialProducts() or a similar method exists in your service
    _specialsFuture = _productService.getDiscountedProducts();
    // Assuming getProducts() fetches the main list for the grid
    _mainProductsFuture = _productService.getProducts();
    //_productService.replaceProductsInFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to start for better padding management
            children: [
              const TopLocationBar(),
              SizedBox(height: h * 0.045),
              const CustomSearchBar(),
              SizedBox(height: h * 0.015),
              const NewCollections(),

              // --- Decora Specials Header ---
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.decora_specials,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.mainText(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigates to the OffersScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OffersScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.see_all,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Decora Specials List (Horizontal) ---
              FutureBuilder<List<Product>>(
                future: _specialsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 260,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading specials: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 260,
                      child: Center(child: Text('No specials available')),
                    );
                  }

                  final specials = snapshot.data!;

                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // Use the actual number of products
                      itemCount: specials.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = specials[index];
                        return SizedBox(
                          width: 250,
                          child: Padding(
                            // Add left padding to the first item for alignment
                            padding: EdgeInsets.only(right: 12.0, left: index == 0 ? 16.0 : 0.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
                                ),
                              ),
                              // Assuming SpecialCard accepts a Product model
                              child: SpecialCard(product: product),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // --- Categories Header ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.categories,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.mainText(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigates to the CategoriesScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.see_all,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


               Categories(),

              // --- Main Product Grid ---
              FutureBuilder<List<Product>>(
                future: _mainProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading products: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  final products = snapshot.data!;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLandscape ? 4 : 2,
                        childAspectRatio: isLandscape ? 1.3 : 0.75,
                        mainAxisSpacing: 0.010 * w,
                        crossAxisSpacing: 0.010 * w,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          ),
                          // Pass the product to CustomCard
                          child: CustomCard(
                            product: product,
                            ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: h * 0.05), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}