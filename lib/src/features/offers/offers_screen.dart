import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isLandscape = w > h;

    return Scaffold(
      backgroundColor: AppColors.background,

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
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: w * 0.025,
                  right: w * 0.025,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: (w ~/ (180)).clamp(
                        2,
                        isLandscape ? 4 : 2,
                      ),
                      childAspectRatio: isLandscape
                          ? w / (h * 1.6)
                          : w / (h / 1.48),
                      mainAxisSpacing: 0.010 * w,
                      crossAxisSpacing: 0.010 * w,

                      children: List.generate(10, (index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProductDetailsScreen(),
                            ),
                          ),
                          child: GestureDetector(
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
                          ),
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
