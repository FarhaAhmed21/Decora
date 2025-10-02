import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.title, required this.img});
  final String title;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Image.asset(img), const SizedBox(height: 8), Text(title)],
    );
  }
}
