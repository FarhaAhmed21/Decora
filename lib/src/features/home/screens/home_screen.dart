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

class HomeScreen extends StatelessWidget {
  final List<Product> products;
  final List<Product> specials;

  const HomeScreen({super.key, required this.products, required this.specials});

  @override
  Widget build(BuildContext context) {
    print("${ specials.length} karen");
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopLocationBar(),
              SizedBox(height: h * 0.045),
              const CustomSearchBar(),
              SizedBox(height: h * 0.015),
              const NewCollections(),
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

              // Specials list
              SizedBox(
                height:isLandscape ?h * 0.6:h*0.25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: specials.length,
                  itemBuilder: (context, index) {
                    final product = specials[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12.0, left: index == 0 ? 16.0 : 0.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
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
              Categories(),
              // Product grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 3 : 2,
                    childAspectRatio: isLandscape ? 0.8: 0.75,
                    mainAxisSpacing: 0.010 * w,
                    crossAxisSpacing: 0.010 * w,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
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
    );
  }
}
