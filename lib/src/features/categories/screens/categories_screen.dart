import 'package:decora/src/features/categories/models/category_model.dart';
import 'package:decora/src/features/categories/widgets/category_card.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final TextEditingController _controller = TextEditingController();
  final List<CategoryModel> categories = [
    CategoryModel(
      id: '1',
      name: 'Living Room',
      imageUrl: 'assets/images/living_room.png',
    ),
    CategoryModel(
      id: '2',
      name: 'Bedroom',
      imageUrl: 'assets/images/bedroom.png',
    ),
    CategoryModel(
      id: '3',
      name: 'Dining Room',
      imageUrl: 'assets/images/kitchen.png',
    ),
    CategoryModel(
      id: '4',
      name: 'Office',
      imageUrl: 'assets/images/bathroom.png',
    ),
    CategoryModel(
      id: '5',
      name: 'Outdoor Room',
      imageUrl: 'assets/images/dining_room.png',
    ),
    CategoryModel(
      id: '6',
      name: 'Kids Room',
      imageUrl: 'assets/images/office.png',
    ),
    CategoryModel(
      id: '6',
      name: 'Decor & Accessories',
      imageUrl: 'assets/images/office.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Categories'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search Furniture',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(6, (index) {
                return CategoryCard(
                  title: categories[index].name,
                  img: categories[index].imageUrl,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
