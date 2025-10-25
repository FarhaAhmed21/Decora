import 'package:flutter/material.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:decora/src/features/product_details/services/product_services.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

import '../product_details/services/product_services.dart';

class NewCollectionScreen extends StatefulWidget {
  const NewCollectionScreen({super.key});

  @override
  State<NewCollectionScreen> createState() => _NewCollectionScreenState();
}

class _NewCollectionScreenState extends State<NewCollectionScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  final ProductService productService = ProductService();
  bool isLoading = true;
  bool hasError = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchNewCollectionProducts();
  }

  Future<void> _fetchNewCollectionProducts() async {
    try {
      final products = await productService.getNewCollectionProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      debugPrint("❌ Error fetching new collection: $e");
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredProducts = allProducts;
      } else {
        isSearching = true;
        filteredProducts = allProducts.where((product) {
          final name = product.name.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isLandscape = w > h;

    return Scaffold(
      backgroundColor: AppColors.background(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 5),
            CustomAppBar(
              title: 'New Collection',
              onBackPressed: () {
                MainLayout.currentIndex = 1;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 5),
            CustomSearchBar(onSearchChanged: _onSearchChanged),
            const SizedBox(height: 10),

            // 🌀 Loading
            if (isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )

            // ❌ Error
            else if (hasError)
              const Expanded(
                child: Center(
                  child: Text(
                    'Failed to load new collection. Please try again later.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )

            // 📭 Empty
            else if (filteredProducts.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )

              // ✅ Grid of products
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLandscape ? 4 : 2,
                      childAspectRatio: isLandscape ? 1.2 : 0.70,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ),
                        ),
                        child: CustomCard(product: product),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
