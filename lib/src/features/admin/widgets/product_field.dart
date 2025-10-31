import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

class ProductField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool validator;
  final TextInputType type;
  final int lines;

  const ProductField({
    super.key,
    required this.controller,
    required this.label,
    this.validator = false,
    this.type = TextInputType.text,
    this.lines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        style: TextStyle(color: AppColors.mainText()),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.mainText()),
          filled: true,
          fillColor: AppColors.cardColor(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator
            ? (v) => v!.isEmpty ? 'Please enter $label' : null
            : null,
      ),
    );
  }
}
