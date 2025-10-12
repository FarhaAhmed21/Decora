import 'package:decora/src/features/cart/pages/main_cart_page.dart';
import 'package:decora/src/features/favourites/screens/favourite_screen.dart';
import 'package:decora/src/features/home/screens/home_screen.dart';
import 'package:decora/src/features/profile/screens/profile_screen.dart';
import 'package:decora/src/shared/components/custom_floating_action_button.dart';
import 'package:decora/src/shared/components/navbar.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  static int currentIndex = 0;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> screens = [
    const HomeScreen(), //0
    const MainCartPage(), //1
    const FavouriteScreen(), //2
    const ProfileScreen(), //3
  ];

  void onTabTapped(int index) {
    setState(() {
      MainLayout.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showNavBar =
        MainLayout.currentIndex == 0 ||
        MainLayout.currentIndex == 3 ||
        MainLayout.currentIndex == 2;

    return Scaffold(
      body: IndexedStack(index: MainLayout.currentIndex, children: screens),
      bottomNavigationBar: showNavBar
          ? CustomBottomNavBar(
              selectedIndex: MainLayout.currentIndex,
              onItemTapped: onTabTapped,
            )
          : null,
      floatingActionButton: showNavBar
          ? const CustomFloatingActionButton()
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
