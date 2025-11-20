import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalog/catalog/catalog_service.dart';
import 'package:catalog/product/product.dart';
import 'package:flutter_riverpod/legacy.dart';

enum PriceSort {
  none,
  lowToHigh,
  highToLow,
}

class CatalogState {
  final bool isLoading;
  final String? error;
  final List<Product> products;
  final String searchQuery;
  final String? selectedCategory;
  final List<String> categories;
  final PriceSort sort;

  const CatalogState({
    this.isLoading = false,
    this.error,
    this.products = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.categories = const [],
    this.sort = PriceSort.none,
  });

  CatalogState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
    String? searchQuery,
    String? selectedCategory,
    List<String>? categories,
    PriceSort? sort,
  }) {
    return CatalogState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      sort: sort ?? this.sort,
    );
  }

  List<Product> get filteredProducts {
    List<Product> list = products;

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      list = list.where((p) => p.category == selectedCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((p) => p.title.toLowerCase().contains(q))
          .toList();
    }
    if (sort == PriceSort.lowToHigh) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == PriceSort.highToLow) {
      list.sort((a, b) => b.price.compareTo(a.price));
    }

    return list;
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
  void changeSort(PriceSort newSort) {
    state = state.copyWith(sort: newSort);
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
