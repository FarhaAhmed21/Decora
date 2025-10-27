import 'package:decora/src/features/vto/screens/vto_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../features/product_details/models/product_model.dart';

class CustomFloatingActionButton extends StatelessWidget {
  List<Product> products;
   CustomFloatingActionButton({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VtoScreen( products:products)),
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
