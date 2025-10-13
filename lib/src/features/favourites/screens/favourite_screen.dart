import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:decora/src/shared/components/custom_card.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/top_location_bar.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: (w ~/ (180 * w)).clamp(
                        2,
                        isLandscape ? 4 : 6,
                      ),
                      childAspectRatio: isLandscape
                          ? w / (h * 1.6)
                          : w / (h / 1.47),
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
                          child: const CustomCard(isdiscount: false),
                        );
                      }),
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
