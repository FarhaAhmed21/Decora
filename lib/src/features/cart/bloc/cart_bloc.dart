import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../service/service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(const CartState()) {
    on<LoadPersonalCart>(_onLoadPersonalCart);
    on<AddProductToCartEvent>(_onAddProductToCart);
    on<MinusProductToCartEvent>(_onMinusProductToCart);
    on<LoadCartTotalsEvent>(_onLoadCartTotals);
    on<LoadSharedCart>(_onLoadSharedCart);
  }

  /// Load personal cart (optimized)
  Future<void> _onLoadPersonalCart(
      LoadPersonalCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(loading: false, items: items));
      add(LoadCartTotalsEvent()); // calculate totals instantly
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// Increase quantity
  Future<void> _onAddProductToCart(
      AddProductToCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addProductToCart(event.productId, event.ctx, event.quantity);
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(items: items));
      add(LoadCartTotalsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Decrease quantity
  Future<void> _onMinusProductToCart(
      MinusProductToCartEvent event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.decreaseProductQuantityCart(event.productId);
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(items: items));
      add(LoadCartTotalsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Load totals instantly using cached products
  Future<void> _onLoadCartTotals(
      LoadCartTotalsEvent event, Emitter<CartState> emit) async {
    try {
      double initialTotal = 0;
      double discountedTotal = 0;

      for (var item in state.items) {
        final product = item['product'];
        final quantity = item['quantity'];
        initialTotal += product.price * quantity;
        discountedTotal += product.price * quantity * (1 - product.discount / 100);
      }

      emit(state.copyWith(
          initialTotal: initialTotal, discountedTotal: discountedTotal));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Load shared carts
  Future<void> _onLoadSharedCart(
      LoadSharedCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await _cartRepository.getSharedCarts();
      emit(state.copyWith(loading: false, items: items));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
