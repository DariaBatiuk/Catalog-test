import 'package:catalog/product/product.dart';
import 'package:flutter_riverpod/legacy.dart';

class CartState {
  final List<Product> items;

  const CartState({
    this.items = const [],
  });

  double get total => items.fold(0, (sum, item) => sum + item.price);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void add(Product product) {
    state = CartState(items: [...state.items, product]);
  }

  void remove(Product product) {
    state = CartState(
      items: state.items.where((p) => p.id != product.id).toList(),
    );
  }

  void clear() {
    state = const CartState(items: []);
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
