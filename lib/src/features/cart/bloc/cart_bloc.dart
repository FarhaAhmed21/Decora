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

  /// load personal cart 
  Future<void> _onLoadPersonalCart(
    LoadPersonalCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(loading: false, items: items));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
  /// increase product quantity in cart

  Future<void> _onAddProductToCart(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.addProductToCart(event.productId, event.ctx, event.quantity);
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(items: items));
      add(LoadCartTotalsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// decrease product quantity in cart
  Future<void> _onMinusProductToCart(
    MinusProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.decreaseProductQuantityCart(event.productId);
      final items = await _cartRepository.getPersonalCartProducts();
      emit(state.copyWith(items: items));
      add(LoadCartTotalsEvent());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Load total prices (initial and discounted)
  Future<void> _onLoadCartTotals(
    LoadCartTotalsEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final totals = await _cartRepository.getCartTotals();
      emit(
        state.copyWith(
          initialTotal: totals['initialTotal']!,
          discountedTotal: totals['discountedTotal'],
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
  /// Load shared Cart Products

  Future<void> _onLoadSharedCart(
    LoadSharedCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await _cartRepository.getSharedCarts();
      emit(state.copyWith(loading: false, items: items));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
  
}
