import 'package:decora/src/features/new_collection/new_collection_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';

class NewCollections extends StatefulWidget {
  final double horizontalPadding;

  const NewCollections({super.key, this.horizontalPadding = 16.0});

  @override
  State<NewCollections> createState() => _NewCollectionsState();
}

class _NewCollectionsState extends State<NewCollections> {
  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);

    final isLandscape = w > h;
    final titleSize = isLandscape ? w * 0.025 : 18.0;
    final subtitleSize = isLandscape ? w * 0.018 : 14.0;
    final buttonTextSize = isLandscape ? w * 0.018 : 14.0;
    final containerHeight = isLandscape ? h * 0.45 : h * 0.18;
    final buttonHeight = isLandscape ? h * 0.05 : h * 0.045;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: h * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: AppColors.cardColor(),
        ),
        padding: EdgeInsets.all(isLandscape ? w * 0.015 : 16.0),
        height: containerHeight,

        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.new_collection,
                        style: TextStyle(
                          fontSize: titleSize,
                          color: AppColors.mainText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: h * 0.005),

                      Text(
                        AppLocalizations.of(
                          context,
                        )!.elevate_your_living_room_with_timeless_sofas,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: AppColors.secondaryText(),
                        ),
                        maxLines: isLandscape ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        AppColors.primary(),
                      ),
                      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      minimumSize: WidgetStatePropertyAll<Size>(
                        Size(isLandscape ? w * 0.15 : 120, buttonHeight),
                      ),
                      shape:
                          const WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                          ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NewCollectionScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.explore,
                        style: TextStyle(
                          fontSize: buttonTextSize,
                          color: AppColors.cardColor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: w * 0.03),

            Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.productCardColor(),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(Assets.luxeSofa, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
