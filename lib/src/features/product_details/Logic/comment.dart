import 'package:flutter/material.dart';

class Comment {
  final String name;
  final String profilePicPath;
  final String text;
  final String date;
  final List<String> imagePaths; // List of image paths for the review

  Comment({
    required this.name,
    required this.profilePicPath,
    required this.text,
    required this.date,
    this.imagePaths = const [], // Default to an empty list
  });
}