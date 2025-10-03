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
