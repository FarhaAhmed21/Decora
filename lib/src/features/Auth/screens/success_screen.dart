import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background(),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            tr.resetPassword,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText(),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.innerCardColor(),
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
                    color: AppColors.mainText(),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.background(),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.043,
            vertical: size.height * 0.045,
          ),
          child: Column(
            children: [
              Image.asset(
                'assets/icons/true_icon.png',
                height: 65,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                tr.passwordResetSuccess,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText(),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                tr.youCanLoginNow,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText(),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary(), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  child: Text(
                    tr.backToLogin,
                    style: TextStyle(
                      color: AppColors.primary(),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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
