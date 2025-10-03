import 'package:decora/cart/pages/my_cart.dart';
import 'package:decora/cart/pages/shared_cart.dart';
import 'package:decora/cart/widgets/cart_app_bar.dart';
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
      ),
    );
  }
}
