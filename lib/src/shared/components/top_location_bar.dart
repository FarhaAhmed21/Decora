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
      padding: EdgeInsets.symmetric(horizontal: width * 0.009),
      child: SizedBox(
        height: height * 0.04,
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
                color: Colors.black,
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(width * 0.03),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(width * 0.001),
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Image.asset(
                    Assets.settingsIcon,
                    color: Colors.black,
                    width: width * 0.025,
                  ),
                ),
              ),
              SizedBox(width: width * 0.009),
              InkWell(
                borderRadius: BorderRadius.circular(width * 0.03),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(width * 0.001),
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Image.asset(
                    Assets.notificationIcon,
                    color: Colors.black,
                    width: width * 0.025,
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
