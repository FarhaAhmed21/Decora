import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';

class NewCollectionScreen extends StatelessWidget {
  const NewCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    return Scaffold(
      backgroundColor: AppColors.background(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
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
            const CustomSearchBar(),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: isLandscape
                      ? w / (h * 1.6)
                      : w / (h / 1.48),
                  mainAxisSpacing: 0.010 * w,
                  crossAxisSpacing: 0.010 * w,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailsScreen(),
                      ),
                    ),
                    child: const CustomCard(isdiscount: false),
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
