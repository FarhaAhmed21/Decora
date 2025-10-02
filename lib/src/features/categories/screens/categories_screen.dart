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
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "Our Categories"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 650,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return buildGridView(
                          categories: CategoriyRepo.categories,
                        );
                      },
                    ),
                  ),
                ],
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
    childAspectRatio: 0.97,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    children: List.generate(categories.length, (index) {
      return CategoryCard(
        title: categories[index].name,
        img: categories[index].imageUrl,
        onTap: () {},
      );
    }),
  );
}
