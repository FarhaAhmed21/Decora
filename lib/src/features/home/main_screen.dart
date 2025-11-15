import 'package:flutter/material.dart';
import 'package:decora/src/features/cart/pages/main_cart_page.dart';
import 'package:decora/src/features/favourites/screens/favourite_screen.dart';
import 'package:decora/src/features/home/screens/home_screen.dart';
import 'package:decora/src/features/profile/screens/profile_screen.dart';
import 'package:decora/src/shared/components/custom_floating_action_button.dart';
import 'package:decora/src/shared/components/navbar.dart';

import '../product_details/models/product_model.dart';
import '../product_details/services/product_services.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  static int currentIndex = 0;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

late Future<List<Product>> mainProductsFuture;

class _MainLayoutState extends State<MainLayout> {
  final ProductService _productService = ProductService();

  late Future<List<Product>> specialsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch data once
    specialsFuture = _productService.getDiscountedProducts();
    mainProductsFuture = _productService.getProducts();
  }

  void onTabTapped(int index) {
    setState(() {
      MainLayout.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([specialsFuture, mainProductsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading products: ${snapshot.error}'),
            ),
          );
        }

        final specials = snapshot.data![0] as List<Product>;
        final products = snapshot.data![1] as List<Product>;

        final screens = [
          HomeScreen(products: products, specials: specials),
          const MainPage(),
          const FavouriteScreen(),
          ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(index: MainLayout.currentIndex, children: screens),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: MainLayout.currentIndex,
            onItemTapped: onTabTapped,
          ),
          floatingActionButton: MainLayout.currentIndex != 1
              ? CustomFloatingActionButton(products: products)
              : null,
          floatingActionButtonLocation: MainLayout.currentIndex != 1
              ? FloatingActionButtonLocation.centerDocked
              : null,
        );
      },
    );
  }
}
