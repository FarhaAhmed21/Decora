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
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.our_Categories),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SizedBox(
                height: 650,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return buildGridView(categories: CategoriyRepo.categories);
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

Widget buildGridView({required List<CategoryModel> categories}) {
  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 0.88,
    mainAxisSpacing: 15,
    crossAxisSpacing: 15,
    children: List.generate(categories.length, (index) {
      return CategoryCard(
        title: categories[index].name,
        img: categories[index].imageUrl,
        onTap: () {},
      );
    }),
  );
}
