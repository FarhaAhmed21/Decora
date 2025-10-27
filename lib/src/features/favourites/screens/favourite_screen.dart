import 'dart:ffi';

import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/favourites/services/fav_service.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:decora/src/shared/components/custom_card.dart';
import 'package:decora/src/shared/components/filter_bottom_sheet.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/top_location_bar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../product_details/models/product_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Product> allFavs = [];
  List<Product> filteredProducts = [];
  bool isSearching = false;
  bool isLoading = true;

  final favService = FavService();

  double _minPrice = 0;
  double _maxPrice = 2000;

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    setState(() => isLoading = true);
    try {
      final favs = await favService.getFavs();
      setState(() {
        allFavs = favs;
        filteredProducts = favs;
      });
    } catch (e) {
      print("Error loading favourites: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredProducts = allFavs;
      } else {
        isSearching = true;
        filteredProducts = allFavs.where((product) {
          final name = product.name.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

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

  void _applyPriceFilter(double min, double max) {
    setState(() {
      filteredProducts = allFavs.where((product) {
        return product.price >= _minPrice && product.price <= _maxPrice;
      }).toList();
    });
  }

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
            CustomSearchBar(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _openFilterSheet,
            ),
            SizedBox(height: h * 0.015),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? const Center(child: Text("No favourites found"))
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                      child: GridView.builder(
                        itemCount: filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isLandscape ? 4 : 2,
                          childAspectRatio: isLandscape ? 1.3 : 0.75,
                          mainAxisSpacing: 0.010 * w,
                          crossAxisSpacing: 0.010 * w,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
