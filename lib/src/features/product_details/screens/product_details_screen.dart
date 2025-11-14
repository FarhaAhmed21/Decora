import 'package:decora/src/features/cart/bloc/cart_bloc.dart';
import 'package:decora/src/features/cart/bloc/cart_event.dart';
import 'package:decora/src/features/cart/bloc/cart_state.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/favourites/services/fav_service.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';
import '../../../shared/theme/app_colors.dart';

import '../../vto/screens/vto_screen.dart';
import '../models/product_model.dart';
import '../services/product_services.dart';
import '../widgets/add_comment_widget.dart';
import '../widgets/build_comment_tile.dart';
import '../widgets/buy_now_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductColor _selectedColor;
  late List<ProductColor> availableColor;
  late String productName;
  late String extraProductInfo;
  late String productDetails;
  late double productPrice;
  late int quantity;
  late bool isFavourite;
  late List<Comment> comments;
  late int buyQuantity;
  final ProductService _productService = ProductService();

  @override
  initState() {
    super.initState();
    comments = [];
    _selectedColor = widget.product.colors.first;
    availableColor = widget.product.colors;
    productName = widget.product.name;
    extraProductInfo = widget.product.extraInfo;
    productDetails = widget.product.details;
    productPrice = widget.product.price;
    quantity = widget.product.quantity;
    isFavourite = false;
    _loadComments();
    _checkFavourite();

    buyQuantity = 0;
  }

  Future<void> _checkFavourite() async {
    isFavourite = await FavService().checkIfFavourite(widget.product.id);
    setState(() {});
  }

  Future<void> _loadComments() async {
    final fetchedComments = await _productService.fetchComments(widget.product);
    setState(() {
      comments = fetchedComments;
    });
  }

  // Helper Widget to build a single comment tile

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);
    final isLandscape = w > h;

    // Determine the size for image containers and spacing based on screen size
    final imageContainerSize = isLandscape
        ? w * 0.08
        : w * 0.15; // Smaller in landscape
    final mainImageHeight = isLandscape
        ? h * 0.5
        : h * 0.25; // Taller in landscape

    return Scaffold(
      backgroundColor: AppColors.background(context),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: AppLocalizations.of(context)!.product_details,
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            // Scrollable content area
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
                          child: SizedBox(
                            height: mainImageHeight, // Responsive height
                            child: Image.network(
                              _selectedColor.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Column(
                          children: [
                            ...List.generate(
                              3,
                              (index) => Padding(
                                padding: EdgeInsets.only(bottom: h * 0.01),
                                child: Container(
                                  width: imageContainerSize,
                                  height: imageContainerSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: AppColors.innerCardColor(context),
                                    border: index == 0
                                        ? Border.all(
                                            color: AppColors.primary(context),
                                            width: 2.0,
                                          )
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // 2. Product Name and Favourites
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: TextStyle(
                                fontSize: isLandscape ? w * 0.025 : 18,
                                color: AppColors.mainText(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              extraProductInfo,
                              style: TextStyle(
                                fontSize: isLandscape ? w * 0.02 : 14,
                                color: AppColors.secondaryText(context),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavourite = !isFavourite;
                              if (isFavourite) {
                                FavService().addfavtolist(widget.product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.product_added_to_favourite_successfully,
                                    ),
                                    backgroundColor: AppColors.primary(context),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                FavService().deletefavfromlist(
                                  widget.product.id,
                                );
                              }
                            });
                          },
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.primary(context),
                            size: isLandscape
                                ? w * 0.03
                                : 30, // Responsive icon size
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.04),
                    // 3. Info Boxes (Placeholder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: isLandscape ? w * 0.1 : 60,
                          height: isLandscape ? w * 0.1 : 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.innerCardColor(context),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.04),
                    // 4. Product Details
                    Text(
                      productDetails,
                      style: TextStyle(
                        fontSize: isLandscape ? w * 0.02 : 16,
                        color: AppColors.secondaryText(context),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    // 6. Colors Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.colors,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.mainText(context),
                          ),
                        ),

                        // Try Virtual Button
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement AR/VR functionality here
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VtoScreen(products: [widget.product]),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Starting Virtual Try-On...'),
                              ),
                            );
                          },
                          icon: Image.asset(
                            Assets.vrnIcon,
                            width: 20,
                            height: 20,
                            color: AppColors.cardColor(context),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.try_virtual,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary(context),
                            foregroundColor: AppColors.cardColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.015,
                            ),
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
                              itemCount: availableColor.length,
                              itemBuilder: (context, index) {
                                final color = availableColor[index];
                                final isSelected = _selectedColor == color;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = color;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: color.color,
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
                          children: [
                            Text(
                              AppLocalizations.of(context)!.price,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.mainText(context),
                              ),
                            ),
                            Text(
                              "\$$productPrice",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.secondaryText(context),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.quantity,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.mainText(context),
                              ),
                            ),
                            Container(
                              width: isLandscape ? w * 0.15 : 102,
                              height: isLandscape ? h * 0.05 : 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.cardColor(context),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (buyQuantity > 1) {
                                          buyQuantity--;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: isLandscape ? w * 0.05 : 30,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        color: AppColors.innerCardColor(
                                          context,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.mainText(context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    buyQuantity.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.mainText(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (buyQuantity < quantity) {
                                          buyQuantity++;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: isLandscape ? w * 0.05 : 30,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        color: AppColors.primary(context),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.cardColor(context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Responsive spacing

                    // 7. Reviews/Comments Section
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.reviews} (${comments.length})",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.mainText(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.see_all,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AddCommentWidget(
                      productId: widget.product.id,
                      onCommentAdded: (newComment) {
                        setState(() {
                          comments.add(
                            newComment,
                          ); // ✅ يضيف الكومنت في نفس اللحظة
                        });
                      },
                    ),

                    // Display comments
                    const SizedBox(height: 8),
                    Column(
                      children: comments
                          .map((comment) => BuildCommentTile(comment))
                          .toList(),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ), // Bottom padding for scroll view
                  ],
                ),
              ),
            ),
          ),

          // 8. Fixed Buy Now Button (Bottom Bar)
          BlocProvider(
            create: (context) => CartBloc(CartRepository()),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return BuyNowButton(
                  h: h,
                  isLandscape: isLandscape,
                  w: w,
                  onpressed: () {
                    context.read<CartBloc>().add(
                      AddProductToCartEvent(productId: widget.product.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
