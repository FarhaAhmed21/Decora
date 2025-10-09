
import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';

class NewCollections extends StatelessWidget {
  const NewCollections({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.cardColor,
          ),
          padding: const EdgeInsets.all(16.0) ,
          height: 180,

          child :Row(
              children: [
                Expanded(

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("New Collection",style: TextStyle(fontSize: 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),
                        const SizedBox(height: 8,),
                        const Text("Elevate your living room with timeless sofas",style: TextStyle(fontSize: 12,color: AppColors.secondaryText ,),maxLines: 2,),
                        const SizedBox(height: 16,),
                        ElevatedButton(onPressed: (){},
                          style:  const ButtonStyle(
                            backgroundColor:WidgetStatePropertyAll<Color>(
                                AppColors.primary),
                            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            ),
                            minimumSize: WidgetStatePropertyAll<Size>(
                              Size(120, 40), // e.g., minimum width of 150 and height of 50
                            ),
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)), // Use a value like 8.0, 15.0, or 25.0 for a pill shape
                              ),
                            ),

                          ),
                          child: const Text("Explore ",style: TextStyle(fontSize: 14,color:AppColors.cardColor,),),
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
