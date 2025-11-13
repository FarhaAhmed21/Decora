
abstract class CartEvent {
  const CartEvent();
}

class LoadPersonalCart extends CartEvent {}
class AddProductToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddProductToCartEvent( {this.quantity = 1, required this.productId});

  @override
  List<Object?> get props => [productId, quantity];
}

class LoadSharedCart extends CartEvent{}
class MinusProductToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const MinusProductToCartEvent({this.quantity = 1, required this.productId});

  @override
  List<Object?> get props => [productId, quantity];
}
class LoadCartTotalsEvent extends CartEvent {

}

