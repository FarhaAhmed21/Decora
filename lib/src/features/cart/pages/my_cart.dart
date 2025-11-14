import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/cart/bloc/cart_bloc.dart';
import 'package:decora/src/features/cart/bloc/cart_event.dart';
import 'package:decora/src/features/cart/bloc/cart_state.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/cart/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(CartRepository())..add(LoadPersonalCart()),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state.items.isEmpty) {
            return Center(
              child: Text(
                '${AppLocalizations.of(context)!.your_cart_is_empty}.',
              ),
            );
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              final product = item['product'];
              final quantity = item['quantity'];

              return ProductCard(
                id: product.id,
                imageUrl: product.colors.first.imageUrl,
                title: product.name,
                category: product.category,
                price: product.price,
                quantity: quantity,
              );
            },
          );
        },
      ),
    );
  }
}
