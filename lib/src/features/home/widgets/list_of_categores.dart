import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

class Categories extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const Categories({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'livingroom', 'bedroom', 'office', 'dining','outdoor'];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary()
                    : AppColors.cardColor(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? AppColors.innerCardColor()
                        : AppColors.mainText(),
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
