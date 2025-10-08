import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/searchbar.dart';
import 'package:decora/src/shared/components/custom_card.dart';
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 5),
            const CustomAppBar(title: 'Decora Specials'),
            const SizedBox(height: 5),
            const CustomSearchBar(),
            Expanded(child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: 10, 
              itemBuilder: (context, index) {
                return const CustomCard(offerPercentage: "20%");
              },
            )), 
          ],
        ),
      ),
    );
  }
}