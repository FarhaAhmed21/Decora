import 'package:decora/src/features/vto/screens/vto_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VtoScreen()),
        );
      },
      backgroundColor: AppColors.primary(),
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
