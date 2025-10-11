import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';
import '../Logic/product_color.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final List<ProductColor> availableColors = [
    ProductColor(
      swatchColor: AppColors.orange,
      imagePath: Assets.luxeSofa,
      colorName: 'Terracotta',
    ),
    ProductColor(
      swatchColor: AppColors.innerCardColor,
      imagePath: Assets.luxeSofa,
      colorName: 'Forest Green',
    ),
    ProductColor(
      swatchColor: AppColors.primary,
      imagePath: Assets.luxeSofa,
      colorName: 'Charcoal Black',
    ),
    ProductColor(
      swatchColor: AppColors.productCardColor,
      imagePath: Assets.bedRoom,
      colorName: 'Mustard Yellow',
    ),
  ];
  late ProductColor _selectedColor;
  String productName="Rustic Charm Sofa";
  String extraProductInfo="Two seater";
  String productDetails ="The Rustic Charm Sofa is a cozy two-seater with timeless rustic style. Durable, comfortable, and perfect for compact spaces or welcoming guests";
  double productPrice =250;
  int quantity =1;
  bool isFavourite =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedColor = availableColors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Product Details"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Container(
                  width: 100,
                    height: 200,
                    child: Image.asset(_selectedColor.imagePath,fit: BoxFit.fill,))),
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.cardColor,
                          border: BoxBorder.all(
                            color: AppColors.primary,
                            width: 1.0,

                          ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 2)

                          )
                          ]
                      ),

                      ),
                    SizedBox(height: 10,),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.innerCardColor,


                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 2)

                            )
                          ]
                      ),


                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.innerCardColor,


                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 2)

                            )
                          ]
                      ),


                    ),


                  ]
                )
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName,style: TextStyle(fontSize: 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),
                    Text(extraProductInfo,style: TextStyle(fontSize: 14,color:AppColors.secondaryText),)
                  ],
                ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFavourite = !isFavourite;
                  if (isFavourite) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.product_added_to_favourite_successfully,
                        ),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 1),
                        // behavior:
                        //     SnackBarBehavior.floating,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                      ),
                    );
                  }
                });
              },
              child: isFavourite
                  ? Image.asset(
                Assets.heartIcon,
                color: AppColors.primary,
                width: 50,
                height: 50,
              )
                  : Image.asset(
                Assets.heartOutline,
                color: AppColors.primary,
                width: 50,
                height: 50,
              ),
            ),
              ],
            ),
            SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.innerCardColor,


                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 2)

                        )
                      ]
                  ),


                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.innerCardColor,


                      boxShadow: [
                        BoxShadow(

                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 2)

                        )
                      ]
                  ),


                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.innerCardColor,


                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 2)

                        )
                      ]
                  ),


                ),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.innerCardColor,


                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 2)

                        )
                      ]
                  ),


                )
              ],
            ),
            SizedBox(height: 32,),
            Text(productDetails,style: TextStyle(fontSize: 16,color:AppColors.secondaryText),),
            SizedBox(height: 16,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text("price:",style: TextStyle(fontSize: 16,color:AppColors.mainText,),),
                    Text("\$${productPrice}",style: TextStyle(fontSize: 20))

                  ]
                ),
                Spacer(),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text("Quantity:",style: TextStyle(fontSize: 16,color:AppColors.mainText,),),
                        Container(
                          width: 102,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.cardColor,

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                   if(quantity>0){
                                     quantity--;
                                   }
                                  });

                                },
                                child: Container(
                                width: 30,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AppColors.innerCardColor,

                                ),
                                  child:Center(child: Text("-",style: TextStyle(fontSize: 16,color:AppColors.mainText,fontWeight: FontWeight.bold,)))
                                ),
                              ),
                              Text( quantity.toString(),style: TextStyle(fontSize: 16,color:AppColors.mainText,fontWeight: FontWeight.bold,)),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: AppColors.primary,

                                  ),
                                  child: Center(child: Text("+",style: TextStyle(fontSize: 16,color:AppColors.cardColor,fontWeight: FontWeight.bold,))
                                ),

                              )
                              )
                            ]
                          )

                        )
                    ]
                )
              ]
            ),
            SizedBox(height: 16,),
            Text("Colors:",style: TextStyle(fontSize: 16,color:AppColors.mainText,),),
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableColors.length,
                      itemBuilder: (context, index) {
                        final color = availableColors[index];
                        final isSelected = _selectedColor == color;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: color.swatchColor,
                              child: isSelected
                                  ? const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                              )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
           Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 50,right: 50),

              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(

                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                  ), onPressed: (){}, child: Text("Buy Now",style: TextStyle(fontSize: 16,color:AppColors.cardColor,))),
            )



          ]
        ),
      ),
    );
  }
}
