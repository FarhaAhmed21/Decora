import 'package:flutter/material.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 246, 246, 246),
      surfaceTintColor: const Color.fromARGB(255, 246, 246, 246),
      elevation: 10,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(
              Image.asset(
                'assets/icons/home-11.png',
                height: 26,
                width: 26,
                color: selectedIndex == 0 ? Colors.black : Colors.grey.shade600,
              ),
              'Home',
              0,
            ),
            _buildNavItem(
              Image.asset(
                'assets/icons/shopping-bag-03.png',
                height: 26,
                width: 26,
                color: selectedIndex == 1 ? Colors.black : Colors.grey.shade600,
              ),
              'Cart',
              1,
            ),
            const SizedBox(width: 48),
            _buildNavItem(
              Image.asset(
                'assets/icons/favourite.png',
                height: 26,
                width: 26,
                color: selectedIndex == 2 ? Colors.black : Colors.grey.shade600,
              ),
              'Favourites',
              2,
            ),
            _buildNavItem(
              Image.asset(
                'assets/icons/User.png',
                height: 26,
                width: 26,
                color: selectedIndex == 3 ? Colors.black : Colors.grey.shade600,
              ),
              'Profile',
              3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(Widget iconWidget, String label, int index) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Colors.black : Colors.grey.shade600;
    final fontWeight = isSelected ? FontWeight.w500 : FontWeight.w400;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              iconWidget,
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 12, fontWeight: fontWeight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}