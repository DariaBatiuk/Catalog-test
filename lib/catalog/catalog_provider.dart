import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:catalog/catalog/catalog_service.dart';
import 'package:catalog/product/product.dart';

class CatalogState {
  final bool isLoading;
  final String? error;
  final List<Product> products;
  final String searchQuery;
  final List<String> categories;
  final String? selectedCategory;

  const CatalogState({
    this.isLoading = false,
    this.error,
    this.products = const [],
    this.searchQuery = '',
    this.categories = const [],
    this.selectedCategory,
  });

  CatalogState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
    String? searchQuery,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return CatalogState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<Product> get filteredProducts {
    Iterable<Product> result = products;

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      result = result.where((p) => p.category == selectedCategory);
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((p) => p.title.toLowerCase().contains(q));
    }

    return result.toList();
  }
}

class CatalogNotifier extends StateNotifier<CatalogState> {
  final CatalogService _service;
  Timer? _debounce;

  CatalogNotifier(this._service) : super(const CatalogState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _service.getProducts();
      final categories = await _service.getCategories();

      state = state.copyWith(
        isLoading: false,
        products: products,
        categories: categories,
      );
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

  void changeCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final catalogServiceProvider = Provider<CatalogService>((ref) {
  return CatalogService();
});
final catalogProvider =
    StateNotifierProvider<CatalogNotifier, CatalogState>((ref) {
  final service = ref.watch(catalogServiceProvider);
  return CatalogNotifier(service);
});
