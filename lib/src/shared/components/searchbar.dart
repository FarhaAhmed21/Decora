// import 'package:decora/core/l10n/app_localizations.dart';
// import 'package:decora/core/utils/app_size.dart';
// import 'package:decora/generated/assets.dart';
// import 'package:decora/src/shared/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class CustomSearchBar extends StatefulWidget {
//   final Function(String)? onSearchChanged;
//   final VoidCallback? onFilterTap;

//   const CustomSearchBar({
//     super.key,
//     required this.onSearchChanged,
//     this.onFilterTap,
//   });

//   @override
//   State<CustomSearchBar> createState() => _CustomSearchBarState();
// }

// class _CustomSearchBarState extends State<CustomSearchBar> {
//   @override
//   Widget build(BuildContext context) {
//     final h = AppSize.height(context);
//     final w = AppSize.width(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: w * 0.035),
//       child: Row(
//         children: [
//           Container(
//             width: w * 0.78,
//             height: h * 0.055,
//             decoration: ShapeDecoration(
//               color: AppColors.cardColor(context),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(w * 0.033),
//               ),
//             ),
//             child: TextField(
//               onChanged: widget.onSearchChanged,
//               decoration: InputDecoration(
//                 prefixIcon: Image.asset(Assets.searchIcon),
//                 hintText: AppLocalizations.of(context)?.searchFurniture,
//                 hintStyle: TextStyle(color: AppColors.secondaryText(context)),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           SizedBox(width: w * 0.01),
//           InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: widget.onFilterTap,
//             child: Container(
//               padding: const EdgeInsets.all(9),
//               decoration: BoxDecoration(
//                 color: AppColors.primary(context),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.asset(Assets.filterIcon),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/generated/assets.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.035),
      child: Row(
        children: [
          Container(
            width: w * 0.78,
            height: h * 0.055,
            decoration: ShapeDecoration(
              color: AppColors.cardColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(w * 0.033),
              ),
            ),
            child: TextField(
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Image.asset(Assets.searchIcon),
                hintText: AppLocalizations.of(context)?.searchFurniture,
                hintStyle: TextStyle(color: AppColors.secondaryText(context)),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: w * 0.01),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primary(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(Assets.filterIcon),
            ),
          ),
        ],
      ),
    );
  }
}
