import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopLocationBar extends StatelessWidget {
  const TopLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: EdgeInsets.only(left: width * 0.02),
      child: Container(
        height: height * 0.04,
        color: Colors.white,
        child: ListTile(
          title: Text(
            AppLocalizations.of(context)!.location,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: width * 0.035,
            ),
          ),
          subtitle: Row(
            children: [
              Image.asset(
                Assets.locationIcon,
                width: width * 0.045,
                height: width * 0.045,
                color: AppColors.mainText,
              ),
              SizedBox(width: width * 0.015),
              Text(
                AppLocalizations.of(context)!.cairoEgypt,
                style: TextStyle(
                  color: AppColors.mainText,
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.04,
                ),
              ),
            ],
          ),
          trailing: InkWell(
            borderRadius: BorderRadius.circular(width * 0.03),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(width * 0.06),
              ),
              child: Image.asset(
                Assets.notificationIcon,
                width: width * 0.07,
                height: width * 0.07,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
