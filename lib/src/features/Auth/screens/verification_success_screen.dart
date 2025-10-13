import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final tr = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(),
        appBar: AppBar(
          backgroundColor: AppColors.background(),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,

          title: Text(
            tr.emailVerification,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? FontAwesomeIcons.chevronRight
                        : FontAwesomeIcons.chevronLeft,
                    color: Colors.black87,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.043,
            vertical: size.height * 0.04,
          ),
          child: Column(
            children: [
              Image.asset(
                'assets/icons/true_icon.png',
                height: size.height * 0.075,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.02),

              Text(
                tr.verificationSuccess,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                tr.verificationSuccessMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText(),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: size.height * 0.05),

              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary(), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    tr.backToLogin,
                    style: TextStyle(color: AppColors.primary(), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
