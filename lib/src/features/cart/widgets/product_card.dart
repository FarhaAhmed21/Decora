import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/bloc/cart_bloc.dart';
import 'package:decora/src/features/cart/bloc/cart_event.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final double price;
  final String imageUrl;
  final int quantity;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
      child: Card(
        elevation: 0,
        color: AppColors.cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  width: AppSize.width(context) * 0.27,
                  height: AppSize.height(context) * 0.13,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTag(category,context),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Text(
                          '\$${price * quantity}',
                          style: TextStyle(color: AppColors.textColor(context)),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _iconButton(
                              icon: Icons.remove,
                              color: Colors.grey,
                              onTap: () {
                                context.read<CartBloc>().add(
                                  MinusProductToCartEvent(productId: id, quantity: quantity),
                                );
                              },
                            ),
                            const SizedBox(width: 18),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor(context),
                              ),
                            ),
                            const SizedBox(width: 18),
                            _iconButton(
                              icon: Icons.add,
                              color: AppColors.primary(context),
                              onTap: () {
                                context.read<CartBloc>().add(
                                  AddProductToCartEvent(productId: id),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 14),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTag(String tag,BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.innerProductCardBorder(context)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      tag,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.innerProductCardTypeText(context),
      ),
    ),
  );
}
