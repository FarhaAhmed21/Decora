import 'package:flutter/material.dart';

class ProductColor {
  final String colorName;
  final String hexColor;
  final String imageUrl;

  ProductColor({
    required this.colorName,
    required this.hexColor,
    required this.imageUrl,
  });

  factory ProductColor.fromMap(Map<String, dynamic> map) {
    return ProductColor(
      colorName: map['colorName'] ?? '',
      hexColor: map['hexColor'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Color get color => _hexToColor(hexColor);

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }
}

class Comment {
  final String userName;
  final String text;
  final String date;
  final String profilePic;
  final String email;

  Comment({
    required this.userName,
    required this.text,
    required this.date,
    required this.profilePic,
    required this.email,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userName: map['userName'] ?? '',
      text: map['text'] ?? '',
      date: map['date'] ?? '',
      profilePic: map['profilePic'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String extraInfo;
  final String details;
  final double price;
  final int discount;
  final bool isFavourite;
  final String category;
  final List<ProductColor> colors;
  final List<Comment> comments;

  Product({
    required this.id,
    required this.name,
    required this.extraInfo,
    required this.details,
    required this.price,
    required this.discount,
    required this.isFavourite,
    required this.category,
    required this.colors,
    required this.comments,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    final colorsList = (data['colors'] as List<dynamic>? ?? [])
        .map((color) => ProductColor.fromMap(color))
        .toList();

    final commentsList = (data['comments'] as List<dynamic>? ?? [])
        .map((comment) => Comment.fromMap(comment))
        .toList();

    return Product(
      id: documentId,
      name: data['name'] ?? '',
      extraInfo: data['extraInfo'] ?? '',
      details: data['details'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toInt(),
      isFavourite: data['isfavourite']?.toString() == 'true',
      category: data['categories'] ?? '',
      colors: colorsList,
      comments: commentsList,
    );
  }
}
