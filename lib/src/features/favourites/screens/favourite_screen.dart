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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopLocationBar(),
            const SizedBox(height: 35),
            const CustomSearchBar(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 650,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(8, (index) {
                        return const CustomCard();
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
