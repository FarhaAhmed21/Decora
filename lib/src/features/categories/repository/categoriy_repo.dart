import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/categories/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoriyRepo {
  BuildContext context;
  CategoriyRepo({required this.context});
  late List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: AppLocalizations.of(context)!.categoryLivingroom,
      imageUrl: Assets.livingRoom,
    ),
    CategoryModel(
      id: '2',
      name: AppLocalizations.of(context)!.categoryBedroom,
      imageUrl: Assets.bedRoom,
    ),
    CategoryModel(
      id: '3',
      name: AppLocalizations.of(context)!.categoryDining,
      imageUrl: Assets.diningRoom,
    ),
    CategoryModel(
      id: '4',
      name: AppLocalizations.of(context)!.categoryOffice,
      imageUrl: Assets.office,
    ),
    CategoryModel(
      id: '5',
      name: AppLocalizations.of(context)!.categoryOutdoor,
      imageUrl: Assets.outdoorRoom,
    ),
  ];
}
