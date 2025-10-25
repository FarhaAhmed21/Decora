import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

import '../product_details/models/product_model.dart';
import '../product_details/screens/product_details_screen.dart';


class OffersScreen extends StatefulWidget {
  final List<Product> specials;

  const OffersScreen({super.key, required this.specials});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late List<Product> filteredProducts;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.specials;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredProducts = widget.specials;
      } else {
        isSearching = true;
        filteredProducts = widget.specials.where((product) {
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
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Decora Specials',
              onBackPressed: () => Navigator.pop(context),
            ),
            CustomSearchBar(onSearchChanged: _onSearchChanged),
            SizedBox(height: h * 0.015),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                child: filteredProducts.isEmpty
                    ? Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText(),
                    ),
                  ),
                )
                    : GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 4 : 2,
                    childAspectRatio:
                    isLandscape ? w / (h * 1.6) : w / (h / 1.48),
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
