import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
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

    // Load shared cart when tab is visible
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

      // Load shared cart when tab becomes visible
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
                style: TextStyle(color: AppColors.textColor()),
              ),
            );
          }

          // We can just take the first shared cart for now
          final sharedCart = state.items.first;
          final products = sharedCart['products'] as List<Map<String, dynamic>>;
          final userIds = sharedCart['userIds'] as List<String>? ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Owners Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        offset: _isVisible
                            ? Offset.zero
                            : const Offset(-1.5, 0),
                        child: Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.owners}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.textColor(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: AppSize.width(context) * 0.3,
                              child: OverlappingImages(
                                images: userIds.map((id) {
                                  // Replace with actual user image URLs if you have them
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
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.view_all,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.textColor(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Product List
                ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = products[index];
                    final product = item['product'];
                    final quantity = item['quantity'] ?? 1;

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
