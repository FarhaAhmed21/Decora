import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/pages/view_all_page.dart';
import 'package:decora/src/features/cart/widgets/product_card.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class SharedCart extends StatefulWidget {
  const SharedCart({super.key});

  @override
  State<SharedCart> createState() => _SharedCartState();
}

class _SharedCartState extends State<SharedCart>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (_controller != controller) {
      _controller?.removeListener(_handleTabChange);
      _controller = controller;
      _controller?.addListener(_handleTabChange);
    }

    if (_isVisible) {
      context.read<CartBloc>().add(LoadSharedCart());
    }
  }

  void _handleTabChange() {
    if (!mounted || _controller == null) return;

    if (!_controller!.indexIsChanging) {
      setState(() {
        _isVisible = _controller!.index == 1;
      });

      if (_isVisible) {
        context.read<CartBloc>().add(LoadSharedCart());
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state.items.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.no_products,
                style: TextStyle(color: AppColors.textColor(context)),
              ),
            );
          }

          // Merge all products from all carts
          final Map<String, Map<String, dynamic>> allProductsMap = {};

          final Set<String> allUserIds = {};

          for (final cart in state.items) {
            final products = (cart['products'] as List<dynamic>?) ?? [];
            final userIds = (cart['userIds'] as List<dynamic>?) ?? [];

            // Collect all userIds
            allUserIds.addAll(userIds.cast<String>());

            // Merge products
            for (final item in products) {
              final mapItem = item as Map<String, dynamic>;
              final product = mapItem['product'];
              final quantity = (mapItem['quantity'] as int?) ?? 1;

              if (product != null) {
                if (allProductsMap.containsKey(product.id)) {
                  allProductsMap[product.id]!['quantity'] += quantity;
                } else {
                  allProductsMap[product.id] = {
                    'product': product,
                    'quantity': quantity,
                  };
                }
              }
            }
          }

          final productsList = allProductsMap.values.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Owners Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        offset: _isVisible ? Offset.zero : const Offset(-1.5, 0),
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.owners}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.textColor(context),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: AppSize.width(context) * 0.3,
                              child: OverlappingImages(
                                images: allUserIds.map((id) {
                                  return NetworkImage(
                                    'https://i.pravatar.cc/150?u=$id',
                                  );
                                }).toList(),
                                imageRadius: 18.0,
                                overlapOffset: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        offset: _isVisible ? Offset.zero : const Offset(1.5, 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ViewAllPage(usersId: allUserIds.toList()),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.view_all,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.textColor(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Products List
                ListView.builder(
                  itemCount: productsList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = productsList[index];
                    final product = item['product'] as dynamic;
                    final quantity = item['quantity'] as int;

                    return ProductCard(
                      id: product.id,
                      imageUrl: product.colors.first.imageUrl,
                      title: product.name,
                      category: product.category,
                      price: product.price,
                      quantity: quantity,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}