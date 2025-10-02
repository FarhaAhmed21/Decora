import 'package:decora/cart/widgets/cart_app_bar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( // ✅ provides TabController to both
      length: 2,
      child: Scaffold(
        appBar: const CartAppBar(),
        body: const TabBarView(
          children: [
            Center(child: Text("My Cart Content")),
            Center(child: Text("Shared Cart Content")),
          ],
        ),
      ),
    );
  }
}
