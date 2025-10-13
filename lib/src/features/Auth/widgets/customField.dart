import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

Widget customField(String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 6),
      TextField(
        cursorColor: AppColors.primary(),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: AppColors.primary(), width: 1.5),
          ),
          hintText: label,
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 14,
          ),
        ),
      ),
    ],
  );
}
