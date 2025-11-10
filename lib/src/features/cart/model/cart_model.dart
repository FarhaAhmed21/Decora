
class Cart {
  final String cartId;
  final List<String> userIds;
  final bool isShared;
  final Map<String, int> products; // productId → quantity

  Cart({
    required this.cartId,
    required this.userIds,
    required this.isShared,
    required this.products,
  });

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'userIds': userIds,
        'isShared': isShared,
        'products': products,
      };

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json['cartId'] ?? '',
        userIds: List<String>.from(json['userIds'] ?? []),
        isShared: json['isShared'] ?? false,
        products: Map<String, int>.from(
          (json['products'] ?? {}).map((key, value) =>
              MapEntry(key.toString(), (value ?? 1).toInt())),
        ),
      );
}
