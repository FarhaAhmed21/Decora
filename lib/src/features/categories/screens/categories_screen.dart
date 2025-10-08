import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/features/categories/models/category_model.dart';
import 'package:decora/src/features/categories/repository/categoriy_repo.dart';
import 'package:decora/src/features/categories/widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: AppLocalizations.of(context)!.our_Categories),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.050,
                  vertical: size.height * 0.015,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return buildGridView(
                      categories: CategoriyRepo.categories,
                      context: context,
                      size: size,
                      isLandscape: isLandscape,
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

Widget buildGridView({
  required List<CategoryModel> categories,
  required BuildContext context,
  required Size size,
  required bool isLandscape,
}) {
  return GridView.count(
    crossAxisCount: (size.width ~/ 180).clamp(2, isLandscape ? 4 : 6),
    childAspectRatio: isLandscape
        ? size.width / (size.height * 2.5)
        : size.width / (size.height / 1.9),
    mainAxisSpacing: size.width * 0.04,
    crossAxisSpacing: size.width * 0.04,
    children: List.generate(categories.length, (index) {
      return CategoryCard(
        title: categories[index].name,
        img: categories[index].imageUrl,
        onTap: () {},
      );
    }),
  );
}
