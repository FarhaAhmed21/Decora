import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/pages/my_cart.dart';
import 'package:decora/src/features/cart/pages/shared_cart.dart';
import 'package:decora/src/features/cart/widgets/cart_app_bar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MainCartPage extends StatelessWidget {
  const MainCartPage({super.key});

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CartAppBar(),
        body: const TabBarView(children: [MyCart(), SharedCart()]),
        
        bottomNavigationBar: Container(
          height: AppSize.height(context) * 0.16,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // dark green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child:  Text(
                  AppLocalizations.of(context)!.checkout,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
