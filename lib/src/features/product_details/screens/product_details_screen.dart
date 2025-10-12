import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';
import '../Logic/product_color.dart';
import '../Logic/comment.dart';
import '../widgets/add_comment_widget.dart' hide AppSize;
import '../widgets/build_comment_tile.dart' hide AppSize;
import '../widgets/buy_now_button.dart'; // Assuming this path is correct



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

  // Dummy data for comments
  final List<Comment> comments = [
    Comment(
      name: "Mona Ahmed",
      profilePicPath: Assets.decoreAccessories, // Assuming you have image paths in Assets
      text: "Its a Verry comfortable sofa",
      date: "10 May 2025",
      imagePaths: [],
    ),
    Comment(
      name: "Abdelrahman Mahmoud",
      profilePicPath: Assets.couchImage,
      text: "It is really beautiful",
      date: "10 May 2025",
      imagePaths: [
        Assets.luxeSofa,
        Assets.bedRoom,
      ],
    ),
    Comment(
      name: "Mona Ahmed",
      profilePicPath: Assets.diningRoom,
      text: "Love the color and material!",
      date: "10 May 2025",
      imagePaths: [],
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
    super.initState();
    _selectedColor = availableColors.first;
  }

  // Helper Widget to build a single comment tile


  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    // Determine the size for image containers and spacing based on screen size
    final imageContainerSize = isLandscape ? w * 0.08 : w * 0.15; // Smaller in landscape
    final mainImageHeight = isLandscape ? h * 0.5 : h * 0.25; // Taller in landscape

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text(AppLocalizations.of(
          context,
        )!.product_details),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded( // Scrollable content area
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Images Section (Main Image + Thumbnails)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: mainImageHeight, // Responsive height
                                child: Image.asset(_selectedColor.imagePath, fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            Column(
                                children: [
                                  // Thumbnails (Using responsive size)
                                  ...List.generate(3, (index) => Padding(
                                    padding: EdgeInsets.only(bottom: h * 0.01),
                                    child: Container(
                                      width: imageContainerSize,
                                      height: imageContainerSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: AppColors.innerCardColor,
                                          border: index == 0 ? Border.all(color: AppColors.primary, width: 2.0) : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            )
                                          ]
                                      ),
                                    ),
                                  )),
                                ]
                            )
                          ],
                        ),
                        SizedBox(height: h * 0.02),

                        // 2. Product Name and Favourites
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName,style: TextStyle(fontSize: isLandscape ? w * 0.025 : 18,color:AppColors.mainText,fontWeight: FontWeight.bold,),),
                                Text(extraProductInfo,style: TextStyle(fontSize: isLandscape ? w * 0.02 : 14,color:AppColors.secondaryText),)
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavourite = !isFavourite;
                                  if (isFavourite) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context,)!.product_added_to_favourite_successfully,),
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Icon(
                                isFavourite ? Icons.favorite : Icons.favorite_border,
                                color: AppColors.primary,
                                size: isLandscape ? w * 0.03 : 30, // Responsive icon size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.04), // Responsive spacing

                        // 3. Info Boxes (Placeholder)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(4, (index) => Container(
                            width: isLandscape ? w * 0.1 : 60,
                            height: isLandscape ? w * 0.1 : 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.innerCardColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2)
                                  )
                                ]
                            ),
                          )),
                        ),
                        SizedBox(height: h * 0.04), // Responsive spacing

                        // 4. Product Details
                        Text(productDetails,style: TextStyle(fontSize: isLandscape ? w * 0.02 : 16,color:AppColors.secondaryText),),
                        SizedBox(height: h * 0.02), // Responsive spacing
                        // 6. Colors Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context,)!.colors,
                              style: TextStyle(fontSize: 16,color:AppColors.mainText,),
                            ),

                            // Try Virtual Button
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement AR/VR functionality here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Starting Virtual Try-On...')),
                                );
                              },
                              icon: Image.asset(
                                Assets.vrnIcon,
                                width: 20,
                                height: 20,
                                color: AppColors.cardColor,
                              ),
                              label: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.try_virtual,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: SizedBox(
                                height: 30,
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
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                        SizedBox(height: h * 0.02),
                        // 5. Price and Quantity
                        Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text(AppLocalizations.of(context,)!.price,style: const TextStyle(fontSize: 16,color:AppColors.mainText,),),
                                    Text("\$${productPrice}",style: const TextStyle(fontSize: 20))
                                  ]
                              ),
                              const Spacer(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text(AppLocalizations.of(context,)!.quantity,style: const TextStyle(fontSize: 16,color:AppColors.mainText,),),
                                    Container(
                                        width: isLandscape ? w * 0.15 : 102,
                                        height: isLandscape ? h * 0.05 : 30,
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
                                                    if(quantity>1){
                                                      quantity--;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                    width: isLandscape ? w * 0.05 : 30,
                                                    height: double.infinity,
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
                                                    width: isLandscape ? w * 0.05 : 30,
                                                    height: double.infinity,
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
                      // Responsive spacing



                        // 7. Reviews/Comments Section
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                          "${AppLocalizations.of(
                          context,
                        )!.reviews} (${comments.length})",
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.mainText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                AppLocalizations.of(
                                  context,
                                )!.see_all,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AddCommentWidget(),
                        // Display comments
                        const SizedBox(height: 8),
                        ...comments.map((comment) => BuildCommentTile(comment,)).toList(),

                        SizedBox(height: h * 0.02), // Bottom padding for scroll view
                      ]
                  ),
                ),
              ),
            ),

            // 8. Fixed Buy Now Button (Bottom Bar)
            BuyNowButton(h: h, isLandscape: isLandscape, w: w,onpressed: (){},)
          ]
      ),
    );
  }
}
