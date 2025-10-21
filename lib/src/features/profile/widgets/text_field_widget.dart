import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.mainText(),
              fontSize: 16,
              fontFamily: 'Montserratt',
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            style: TextStyle(color: AppColors.secondaryText()),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.secondaryText(),
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.cardColor(),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
