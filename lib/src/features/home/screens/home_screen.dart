import 'package:decora/src/features/categories/screens/categories_screen.dart';
import 'package:decora/src/features/offers/offers_screen.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
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
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProductDetailsScreen(),
                            ),
                          ),
                          child: const SpecialCard(),
                        ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: (w ~/ (180 * w)).clamp(
                        2,
                        isLandscape ? 4 : 6,
                      ),
                      childAspectRatio: isLandscape
                          ? w / (h * 1.6)
                          : w / (h / 1.48),
                      mainAxisSpacing: 0.010 * w,
                      crossAxisSpacing: 0.010 * w,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProductDetailsScreen(),
                            ),
                          ),
                          child: const CustomCard(
                            isdiscount: true,
                            offerPercentage: "20%",
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
