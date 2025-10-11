import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

class Categories extends StatefulWidget {

  Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List <String> categories =["All","Living Room","Bedroom","Dining Room","Office","Outdoor Room","Kids Room","Decor & Accessories"];

  int chosen = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              setState(() {
                chosen = index;
              });
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 👈 ADDED PADDING

                alignment: Alignment.center,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(16.0),
                    color: chosen==index?AppColors.primary:AppColors.cardColor
                ),
                child: Text(categories[index],style: TextStyle(fontSize: 14,color:chosen==index?AppColors.innerCardColor:AppColors.mainText,fontWeight: FontWeight.bold,))

            ),
          );
        },

      ),
    );
  }
}

