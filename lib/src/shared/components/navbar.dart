import 'package:decora/src/shared/theme/app_colors.dart';
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
    return selectedIndex != 1
        ? BottomAppBar(
            color: AppColors.background(),
            elevation: 10,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: CustomPaint(
              painter: _TopBorderPainter(),
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
                        color: selectedIndex == 0
                            ? (AppTheme.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(255, 255, 255, 0.5))
                            : (AppTheme.isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 0.5)
                                  : Colors.white),
                      ),
                      'Home',
                      0,
                    ),
                    _buildNavItem(
                      Image.asset(
                        'assets/icons/shopping-bag-03.png',
                        height: 26,
                        width: 26,
                        color: selectedIndex == 1
                            ? (AppTheme.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(255, 255, 255, 0.5))
                            : (AppTheme.isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 0.5)
                                  : Colors.white),
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
                        color: selectedIndex == 2
                            ? (AppTheme.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(255, 255, 255, 0.5))
                            : (AppTheme.isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 0.5)
                                  : Colors.white),
                      ),
                      'Favourites',
                      2,
                    ),
                    _buildNavItem(
                      Image.asset(
                        'assets/icons/User.png',
                        height: 26,
                        width: 26,
                        color: selectedIndex == 3
                            ? (AppTheme.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(255, 255, 255, 0.5))
                            : (AppTheme.isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 0.5)
                                  : Colors.white),
                      ),
                      'Profile',
                      3,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildNavItem(Widget iconWidget, String label, int index) {
    final isSelected = index == selectedIndex;
    final color = isSelected
        ? (AppTheme.isDarkMode
              ? Colors.white
              : const Color.fromRGBO(255, 255, 255, 0.5))
        : (AppTheme.isDarkMode
              ? const Color.fromRGBO(255, 255, 255, 0.5)
              : Colors.white);
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
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    double notchWidth = 60;
    double notchRadius = notchWidth / 2;
    double centerX = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - notchRadius, 0);

    path.arcToPoint(
      Offset(centerX + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
