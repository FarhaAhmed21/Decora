import 'package:decora/src/features/cart/pages/main_cart_page.dart';
import 'package:decora/src/features/favourites/screens/favourite_screen.dart';
import 'package:decora/src/features/home/screens/home_screen.dart';
import 'package:decora/src/features/profile/screens/profile_screen.dart';
import 'package:decora/src/shared/components/custom_floating_action_button.dart';
import 'package:decora/src/shared/components/navbar.dart';
import 'package:flutter/material.dart';

import '../product_details/models/product_model.dart';
import '../product_details/services/product_services.dart';

class MainLayout extends StatefulWidget {

  const MainLayout({super.key});
  static int currentIndex = 0;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}
class _MainLayoutState extends State<MainLayout> {
  final ProductService _productService = ProductService();

  late Future<List<Product>> specialsFuture;
  late Future<List<Product>> mainProductsFuture;

  @override
  void initState() {
    super.initState();
    specialsFuture = _productService.getDiscountedProducts();

    mainProductsFuture = _productService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([specialsFuture, mainProductsFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final specials = snapshot.data![0] as List<Product>;
        final products = snapshot.data![1] as List<Product>;

        final screens = [
          HomeScreen(products: products, specials: specials), // ✅ pass data here
          const MainCartPage(),
          const FavouriteScreen( favProducts: []),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: MainLayout.currentIndex,
            children: screens,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: MainLayout.currentIndex,
            onItemTapped: (index) {
              setState(() {
                MainLayout.currentIndex = index;
              });
            },
          ),
          floatingActionButton: CustomFloatingActionButton(products: products), // ✅ pass to FAB too
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
