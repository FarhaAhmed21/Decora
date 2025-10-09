import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';
import '../../../shared/components/custom_card.dart';
import '../../../shared/components/searchbar.dart';
import '../../../shared/components/special_card.dart';
import '../../../shared/components/top_location_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/new_collections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List <String> categories =["All","Living Room","Bedroom","Dining Room","Office","Outdoor Room","Kids Room","Decor & Accessories"];
  int chosen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: SingleChildScrollView(
    child: SafeArea(child: Column(
          children: [
            const TopLocationBar(),
            const SizedBox(height: 16),
            const CustomSearchBar(),

            const NewCollections(),
           const Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 8.0),
              child: Row(
                children: [
                  Text("Decora Specials",style: TextStyle(fontSize: 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),
                  const Spacer(),
                  Text("See All",style: TextStyle(fontSize: 14,color:AppColors.primary,fontWeight: FontWeight.bold,),),
                ],
              )
            ),
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                return const SizedBox(
                    width: 250,
                    child: Padding(
                      padding :EdgeInsets.only(right: 12.0),
                      child: SpecialCard(),
                    ));
              },

              ),
            ),
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Categories",style: TextStyle(fontSize: 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),
                    Spacer(),
                    Text("See All",style: TextStyle(fontSize: 14,color:AppColors.primary,fontWeight: FontWeight.bold,),),
                  ],
                )
            ),

            SizedBox(
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
            ),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(8, (index) {
                return const CustomCard();
              }),
            ),
          ],
        ),
    ),
  ),
)
    );
  }
}
