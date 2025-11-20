import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalog/api/api.dart';
import 'package:catalog/product/product.dart';
import 'package:flutter_riverpod/legacy.dart';

class CatalogState {
  final bool isLoading;
  final String? error;
  final List<Product> products;
  final String searchQuery;

  const CatalogState({
    this.isLoading = false,
    this.error,
    this.products = const [],
    this.searchQuery = '',
  });

  CatalogState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
    String? searchQuery,
  }) {
    return CatalogState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    final q = searchQuery.toLowerCase();
    return products
        .where((p) => p.title.toLowerCase().contains(q))
        .toList();
  }
}

class CatalogNotifier extends StateNotifier<CatalogState> {
  final Api _api;
  Timer? _debounce;

  CatalogNotifier(this._api) : super(const CatalogState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _api.getProducts();
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() => loadProducts();

  void changeSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(searchQuery: query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final apiProvider = Provider<Api>((ref) => Api());
final catalogProvider =
    StateNotifierProvider<CatalogNotifier, CatalogState>((ref) {
  final api = ref.watch(apiProvider);
  return CatalogNotifier(api);
});
