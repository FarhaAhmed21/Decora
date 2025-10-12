import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Custom_floating_action_button extends StatelessWidget {
  const Custom_floating_action_button({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primaryGreen,
      shape: const CircleBorder(),
      child: Image.asset(
        'assets/icons/VTO.png',
        height: 24,
        width: 24,
        color: Colors.white,
      ),
    );
  }
}
