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
      imageUrl:
          map['imageUrl'] ??
          'https://safainv.sa/front/assets/images/default.jpg',
    );
  }

  Map<String, dynamic> toMap() {
    return {'colorName': colorName, 'hexColor': hexColor, 'imageUrl': imageUrl};
  }

  Color get color => _hexToColor(hexColor);

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }
}

class Comment {
  final String text;
  final String date;
  final String userid;

  Comment({required this.text, required this.date, required this.userid});

  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(
      text: json['text'] ?? '',
      date: json['date'] ?? '',
      userid: json['userid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'date': date, 'userid': userid};
  }
}

class Product {
  final String id;
  final String name;
  final String extraInfo;
  final String details;
  final double price;
  final int discount;
  final int quantity;
  final bool isNewCollection;
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
    required this.quantity,
    required this.isNewCollection,
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
      quantity: (data['quantity'] ?? 0).toInt(),
      isNewCollection: data['isNewCollection'] ?? false,
      category: data['categories'] ?? '',
      colors: colorsList,
      comments: commentsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'extraInfo': extraInfo,
      'details': details,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'isNewCollection': isNewCollection,
      'categories': category,
      'colors': colors.map((c) => c.toMap()).toList(),
      'comments': comments.map((c) => c.toMap()).toList(),
      'id': id,
    };
  }
}
