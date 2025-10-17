import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void showProviderConflictDialog(BuildContext context) {
  final rootContext = context;
  final lang = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    barrierDismissible: false,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.orange(),
                size: screenWidth * 0.14,
              ),
              const SizedBox(height: 15),
              Text(
                lang.accountAlreadyExistsTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                  color: AppColors.primary(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang.accountAlreadyExistsDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.secondaryText(),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.18,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.secondaryText()),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        lang.cancel,
                        style: TextStyle(
                          color: AppColors.secondaryText(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 19,
                      ),
                      label: Text(
                        lang.continueWithGoogle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext);

                        final user = await AuthService().signInWithGoogle();

                        if (user != null && rootContext.mounted) {
                          Navigator.pushReplacement(
                            rootContext,
                            MaterialPageRoute(
                              builder: (_) => const MainLayout(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
