import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../shared/components/custom_card.dart';
import '../../../shared/components/searchbar.dart';
import '../../../shared/components/special_card.dart';
import '../../../shared/components/top_location_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../categories/screens/categories_screen.dart';
import '../../offers/offers_screen.dart';
import '../../product_details/models/product_model.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../widgets/list_of_categores.dart';
import '../widgets/new_collections.dart';

class HomeScreen extends StatefulWidget {
  final List<Product> products;
  final List<Product> specials;

  const HomeScreen({super.key, required this.products, required this.specials});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> filteredProducts;
  bool isSearching = false;
  late String selectedCategory= 'All';

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;

  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredProducts = widget.products;
      } else {
        isSearching = true;
        filteredProducts = widget.products.where((product) {
          final name = product.name.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }
  List<Product> get filteredByCategory {
    if (selectedCategory == 'All') {
      return widget.products;
    } else {
      return widget.products
          .where((product) => product.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;
    final visibleProducts = filteredByCategory;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopLocationBar(),
            SizedBox(height: h * 0.045),
            CustomSearchBar(onSearchChanged: _onSearchChanged),
            SizedBox(height: h * 0.015),

            // in search
            if (isSearching)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.035),
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
                      crossAxisCount: isLandscape ? 3 : 2,
                      childAspectRatio: isLandscape ? 0.8 : 0.75,
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
              )
            else
            // search is done
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NewCollections(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 8.0),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  OffersScreen(specials:widget.specials),
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
                      SizedBox(
                        height: isLandscape ? h * 0.6 : h * 0.25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.specials.length,
                          itemBuilder: (context, index) {
                            final product = widget.specials[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: 12.0, left: index == 0 ? 16.0 : 0.0),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailsScreen(product: product),
                                  ),
                                ),
                                child: SpecialCard(product: product),
                              ),
                            );
                          },
                        ),
                      ),
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
                       Categories(selectedCategory:selectedCategory, onCategorySelected: (category) {
    setState(() {
    selectedCategory = category;
    });
    },),
                SizedBox(height: h * 0.015),


                Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                child: visibleProducts.isEmpty
                    ? Center(
                  child: Text(
                    'No products in this category',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText(),
                    ),
                  ),
                )
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visibleProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 3 : 2,
                    childAspectRatio: isLandscape ? 0.8 : 0.75,
                    mainAxisSpacing: 0.010 * w,
                    crossAxisSpacing: 0.010 * w,
                  ),
                  itemBuilder: (context, index) {
                    final product = visibleProducts[index];
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

            SizedBox(height: h * 0.05),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
