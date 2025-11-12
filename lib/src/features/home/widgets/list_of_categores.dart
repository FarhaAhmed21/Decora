import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../shared/components/list_of_categories.dart';

class Categories extends StatelessWidget {
  final String selectedCategory; // English key for filtering
  final ValueChanged<String> onCategorySelected;
  final List<CategoryItem> categories;

  const Categories({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.key;
          return GestureDetector(
            onTap: () => onCategorySelected(category.key), // always English
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary(context)
                    : AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category.label, // translated label
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? AppColors.innerCardColor(context)
                        : AppColors.mainText(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
