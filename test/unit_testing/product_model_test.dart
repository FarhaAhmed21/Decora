// test/product_model_test.dart
import 'package:flutter/material.dart'; // Required for Color class
import 'package:flutter_test/flutter_test.dart';
// Note: You will need to adjust this import path to match where your Product class is defined
// Since you provided the code inline, I'll assume it's accessible.
// For demonstration, I will copy the Product class definition directly into the test file.

// --- PRODUCT MODEL DEFINITIONS (Copied for self-contained testing) ---
// In a real project, these would be imported:
// import 'package:decora/src/features/product_details/models/product_model.dart';

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
      text: json['text']??'',
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
        .map((color) => ProductColor.fromMap(color as Map<String, dynamic>)) // Cast to Map<String, dynamic>
        .toList();

    final commentsList = (data['comments'] as List<dynamic>? ?? [])
        .map((comment) => Comment.fromMap(comment as Map<String, dynamic>)) // Cast to Map<String, dynamic>
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

// --- UNIT TESTS START ---

void main() {
  group('ProductColor Unit Tests', () {
    const String colorHex = 'FF5733';
    const Color expectedColor = Color(0xFFFF5733);
    final Map<String, dynamic> colorMap = {
      'colorName': 'Reddish Orange',
      'hexColor': colorHex,
      'imageUrl': 'image_url',
    };

    test('ProductColor.fromMap creates instance correctly', () {
      final color = ProductColor.fromMap(colorMap);
      expect(color.colorName, 'Reddish Orange');
      expect(color.hexColor, colorHex);
      expect(color.imageUrl, 'image_url');
    });

    test('ProductColor.fromMap handles null/missing values with defaults', () {
      final color = ProductColor.fromMap({});
      expect(color.colorName, '');
      expect(color.hexColor, '');
      expect(color.imageUrl, 'https://safainv.sa/front/assets/images/default.jpg');
    });

    test('ProductColor.color computes the correct Flutter Color', () {
      final color = ProductColor(
        colorName: 'Test',
        hexColor: colorHex,
        imageUrl: 'url',
      );
      expect(color.color, expectedColor);
    });

    test('ProductColor.toMap converts to map correctly', () {
      final color = ProductColor.fromMap(colorMap);
      expect(color.toMap(), colorMap);
    });
  });

  group('Comment Unit Tests', () {
    final Map<String, dynamic> commentMap = {
      'text': 'Great product!',
      'date': '2023-10-27',
      'userid': 'user123',
    };

    test('Comment.fromMap creates instance correctly', () {
      final comment = Comment.fromMap(commentMap);
      expect(comment.text, 'Great product!');
      expect(comment.date, '2023-10-27');
      expect(comment.userid, 'user123');
    });

    test('Comment.fromMap handles null/missing values with empty strings', () {
      final comment = Comment.fromMap({});
      expect(comment.text, '');
      expect(comment.date, '');
      expect(comment.userid, '');
    });

    test('Comment.toMap converts to map correctly', () {
      final comment = Comment.fromMap(commentMap);
      expect(comment.toMap(), commentMap);
    });
  });

  group('Product Unit Tests', () {
    const String documentId = 'prod_001';
    final Map<String, dynamic> productData = {
      'name': 'Test Lamp',
      'extraInfo': 'Edison style',
      'details': 'Metal and glass',
      'price': 150.50,
      'discount': 15,
      'quantity': 5,
      'isNewCollection': true,
      'categories': 'Lighting',
      'colors': [
        {'colorName': 'Black', 'hexColor': '000000', 'imageUrl': 'url1'}
      ],
      'comments': [
        {'text': 'Nice light', 'date': '2023-11-01', 'userid': 'user_a'}
      ],
    };

    test('Product.fromMap creates instance correctly with complex data', () {
      final product = Product.fromMap(productData, documentId);

      expect(product.id, documentId);
      expect(product.name, 'Test Lamp');
      expect(product.price, 150.50);
      expect(product.discount, 15);
      expect(product.isNewCollection, isTrue);
      expect(product.category, 'Lighting');

      // Check nested objects
      expect(product.colors.length, 1);
      expect(product.colors.first.colorName, 'Black');
      expect(product.colors.first.hexColor, '000000');

      expect(product.comments.length, 1);
      expect(product.comments.first.text, 'Nice light');
    });

    test('Product.fromMap handles null or missing fields with defaults', () {
      final Map<String, dynamic> minimalData = {};
      final product = Product.fromMap(minimalData, 'prod_002');

      expect(product.id, 'prod_002');
      expect(product.name, '');
      expect(product.price, 0.0);
      expect(product.discount, 0);
      expect(product.quantity, 0);
      expect(product.isNewCollection, isFalse);
      expect(product.category, '');
      expect(product.colors, isEmpty);
      expect(product.comments, isEmpty);
    });

    test('Product.toMap converts instance back to map correctly', () {
      final product = Product.fromMap(productData, documentId);
      final map = product.toMap();

      // Check top-level properties
      expect(map['name'], 'Test Lamp');
      expect(map['price'], 150.50);
      expect(map['categories'], 'Lighting');
      expect(map['id'], documentId);

      // Check nested list conversion
      expect((map['colors'] as List).length, 1);
      expect((map['comments'] as List).length, 1);

      // Check data fidelity (deep equality on the maps)
      final expectedMap = { ...productData, 'id': documentId, 'categories': productData['categories'] }; // Adjust for the key difference
      expect(map['colors'], expectedMap['colors']);
      expect(map['comments'], expectedMap['comments']);
    });
  });
}
// End of test file