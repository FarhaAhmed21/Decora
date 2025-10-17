import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/core/l10n/app_localizations.dart';

Future<void> showErrorDialog(BuildContext context, String message) async {
  final lang = AppLocalizations.of(context)!;

  return showDialog(
    context: context,
    builder: (dialogContext) {
      final screenWidth = MediaQuery.of(context).size.width;
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenWidth * 0.06,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.orange(),
                size: screenWidth * 0.14,
              ),
              const SizedBox(height: 15),
              Text(
                lang.loginFailedTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                  color: AppColors.primary(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.secondaryText(),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: screenWidth * 0.35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    lang.ok,
                    style: TextStyle(
                      color: AppColors.background(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
