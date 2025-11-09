import 'package:decora/src/shared/components/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:decora/src/features/product_details/services/product_services.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

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

  double _minPrice = 0;
  double _maxPrice = 2000;

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

  // 🔍 Search logic
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

  // ✅ Apply price filter
  void _applyPriceFilter(double min, double max) {
    setState(() {
      filteredProducts = allProducts.where((product) {
        return product.price >= min && product.price <= max;
      }).toList();
    });
  }

  // ✅ Open shared filter sheet
  void _openFilterSheet() {
    showFilterBottomSheet(
      context: context,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      onApply: (min, max) {
        setState(() {
          _minPrice = min;
          _maxPrice = max;
        });
        _applyPriceFilter(min, max);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isLandscape = w > h;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            //SizedBox(height: MediaQuery.of(context).padding.top + 5),
            CustomAppBar(
              title: 'New Collection',
              onBackPressed: () {
                MainLayout.currentIndex = 1;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 5),
            CustomSearchBar(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _openFilterSheet, // ✅ Added filter button
            ),
            const SizedBox(height: 10),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
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
            // ✅ Products Grid
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 4 : 2,
                    childAspectRatio: isLandscape
                        ? w / (h * 1.6)
                        : w / (h / 1.48),
                    mainAxisSpacing: 0.010 * w,
                    crossAxisSpacing: 0.010 * w,
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
