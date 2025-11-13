
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

  factory Cart.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final Map<String, int> parsedProducts = {};

    if (rawProducts is Map) {
      rawProducts.forEach((key, value) {
        if (key != null) {
          parsedProducts[key.toString()] =
              (value is int) ? value : int.tryParse(value.toString()) ?? 1;
        }
      });
    }

    return Cart(
      cartId: json['cartId']?.toString() ?? '',
      userIds: (json['userIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
      isShared: json['isShared'] ?? false,
      products: parsedProducts,
    );
  }
}


 

