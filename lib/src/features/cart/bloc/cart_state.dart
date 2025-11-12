class CartState {
  final bool loading;
  final List<Map<String, dynamic>> items;
  final String? error;
  final double initialTotal;
  final double discountedTotal;

  const CartState({
    this.loading = false,
    this.items = const [],
    this.error,
    this.initialTotal = 0.0,
    this.discountedTotal = 0.0,
  });

  CartState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? items,
    String? error,
    double? initialTotal,
    double? discountedTotal,
  }) {
    return CartState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
      initialTotal: initialTotal ?? this.initialTotal,
      discountedTotal: discountedTotal ?? this.discountedTotal,
    );
  }
}
