import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
class CategoryItem {
  final String key;       // Original English category (used for filtering)
  final String label;     // Translated label for UI

  CategoryItem({required this.key, required this.label});
}
List<CategoryItem> getTranslatedCategories(BuildContext context) {
  return [
    CategoryItem(key: 'All', label: AppLocalizations.of(context)!.categoryAll),
    CategoryItem(key: 'livingroom', label: AppLocalizations.of(context)!.categoryLivingroom),
    CategoryItem(key: 'bedroom', label: AppLocalizations.of(context)!.categoryBedroom),
    CategoryItem(key: 'office', label: AppLocalizations.of(context)!.categoryOffice),
    CategoryItem(key: 'dining', label: AppLocalizations.of(context)!.categoryDining),
    CategoryItem(key: 'outdoor', label: AppLocalizations.of(context)!.categoryOutdoor),
  ];
}

