
class Cart {
  final String cartId;
  final List<String> userIds;
  final Map<String, int> products; 

  Cart({
    required this.cartId,
    required this.userIds,
    required this.products,
  });

  Map<String, dynamic> toJson() => {
        'cartId': cartId,
        'userIds': userIds,
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
      products: parsedProducts,
    );
  }
}


 

