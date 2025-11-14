
abstract class CartEvent {
  const CartEvent();
}

class LoadPersonalCart extends CartEvent {}
class AddProductToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddProductToCartEvent( {this.quantity = 1, required this.productId});

}

class LoadSharedCart extends CartEvent{}
class MinusProductToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const MinusProductToCartEvent({this.quantity = 1, required this.productId});


}
class LoadCartTotalsEvent extends CartEvent {

}

