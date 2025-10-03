import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/categories/models/category_model.dart';

class CategoriyRepo {
  static List<CategoryModel> categories = [
    CategoryModel(id: '1', name: 'Living Room', imageUrl: Assets.livingRoom),
    CategoryModel(id: '2', name: 'Bedroom', imageUrl: Assets.bedRoom),
    CategoryModel(id: '3', name: 'Dining Room', imageUrl: Assets.diningRoom),
    CategoryModel(id: '4', name: 'Office', imageUrl: Assets.office),
    CategoryModel(id: '5', name: 'Outdoor Room', imageUrl: Assets.outdoorRoom),
    CategoryModel(id: '6', name: 'Kids Room', imageUrl: Assets.kidsRoom),
    CategoryModel(
      id: '6',
      name: 'Decor & Accessories',
      imageUrl: Assets.decoreAccessories,
    ),
  ];
}
