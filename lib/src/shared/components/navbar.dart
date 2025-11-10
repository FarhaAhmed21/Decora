import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // Selector هنا يراقب فقط isDarkMode ويعيد بناء الـ widget لما يتغير
    return Selector<AppThemeProvider, bool>(
      selector: (_, provider) => provider.isDarkMode,
      builder: (context, isDarkMode, child) {
        return BottomAppBar(
          color: AppColors.background(context),
          elevation: 10,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: CustomPaint(
            painter: _TopBorderPainter(isDarkMode: isDarkMode),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    'assets/icons/home-11.png',
                    AppLocalizations.of(context)!.home,
                    0,
                    isDarkMode,
                  ),
                  _buildNavItem(
                    context,
                    'assets/icons/shopping-bag-03.png',
                    AppLocalizations.of(context)!.cart,
                    1,
                    isDarkMode,
                  ),
                  const SizedBox(width: 48),
                  _buildNavItem(
                    context,
                    'assets/icons/favourite.png',
                    AppLocalizations.of(context)!.favourite,
                    2,
                    isDarkMode,
                  ),
                  _buildNavItem(
                    context,
                    'assets/icons/User.png',
                    AppLocalizations.of(context)!.profile,
                    3,
                    isDarkMode,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String iconPath,
    String label,
    int index,
    bool isDarkMode,
  ) {
    final isSelected = index == selectedIndex;
    final color = isSelected
        ? (isDarkMode ? Colors.white : Colors.black)
        : (isDarkMode
              ? const Color.fromARGB(128, 107, 107, 107)
              : const Color.fromARGB(128, 52, 51, 51));
    final fontWeight = isSelected ? FontWeight.w500 : FontWeight.w400;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(iconPath, height: 26, width: 26, color: color),
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
  final bool isDarkMode;

  _TopBorderPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05)
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
  bool shouldRepaint(covariant _TopBorderPainter oldDelegate) {
    // نعيد الرسم فقط لو تغير isDarkMode
    return oldDelegate.isDarkMode != isDarkMode;
  }
}
