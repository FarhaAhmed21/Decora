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

            const CustomAppBar(title: 'Decora Specials'),

            const CustomSearchBar(),
            SizedBox(height: h * 0.015),

            // Expanded ensures the GridView takes up all remaining space
            Expanded(
              child: Padding( // Add vertical padding here for spacing from the search bar
                padding: EdgeInsets.only(top: 10.0, left: w * 0.025, right: w * 0.025), // Added horizontal padding for consistency
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      // Fixed parameters from the old GridView.builder are now replaced with dynamic ones
                      crossAxisCount: (w ~/ (180)).clamp( // Using 180 as a rough item width guide
                        2,
                        isLandscape ? 4 : 2, // Adjusted max based on typical mobile layout
                      ),
                      // The aspect ratio from your FavouriteScreen logic
                      childAspectRatio: isLandscape
                          ? w / (h * 1.6)
                          : w / (h / 1.48),
                      // Dynamic spacing logic from your FavouriteScreen
                      mainAxisSpacing: 0.010 * w,
                      crossAxisSpacing: 0.010 * w,

                      // The list of items
                      children: List.generate(10, (index) {
                        // Pass necessary props to CustomCard
                        return const CustomCard(isdiscount: true, offerPercentage: "20%");
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