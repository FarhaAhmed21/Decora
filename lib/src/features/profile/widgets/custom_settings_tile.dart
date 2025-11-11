import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  static final BorderRadius tileBorderRadius = BorderRadius.circular(8);

  const CustomSettingsTile({
    super.key,
    required this.title,
    this.iconPath = 'assets/icons/arrow-left-01.png',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),

      child: ClipRRect(
        borderRadius: tileBorderRadius,
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromARGB(255, 220, 220, 220),
          borderRadius: tileBorderRadius,

          child: Container(
            height: 62,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.cardColor(context)),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.mainText(context),
                      fontFamily: 'Montserratt',
                    ),
                  ),

                  Image.asset(iconPath, height: 20, width: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
