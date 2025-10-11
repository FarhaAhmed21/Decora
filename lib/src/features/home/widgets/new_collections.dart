
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';

class NewCollections extends StatelessWidget {
  const NewCollections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    //final isLandscape = w > h;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.cardColor,
          ),
          padding: const EdgeInsets.all(16.0) ,
          height:h* 0.1666,

          child :Row(
              children: [
                Expanded(

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(AppLocalizations.of(
                          context,
                        )!.new_collection,style:const TextStyle(fontSize: 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),

                         Text( AppLocalizations.of(
                          context,
                        )!.elevate_your_living_room_with_timeless_sofas,style: const TextStyle(fontSize: 14,color: AppColors.secondaryText ,),maxLines: 2,),

                        ElevatedButton(onPressed: (){},
                          style:  ButtonStyle(
                            backgroundColor:const WidgetStatePropertyAll<Color>(
                                AppColors.primary),
                            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            ),
                            minimumSize: WidgetStatePropertyAll<Size>(
                              Size(120, h *0.029), // e.g., minimum width of 150 and height of 50
                            ),
                            shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)), // Use a value like 8.0, 15.0, or 25.0 for a pill shape
                              ),
                            ),

                          ),
                          child:  Text(AppLocalizations.of(
                            context,
                          )!.explore,style: const TextStyle(fontSize: 14,color:AppColors.cardColor,),),
                        )

                      ]
                  ),
                ),
                Expanded(

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.productCardColor,
                    ),

                    child: Image.asset(
                      Assets.luxeSofa,

                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}
