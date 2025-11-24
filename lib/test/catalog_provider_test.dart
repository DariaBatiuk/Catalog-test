import 'package:catalog/catalog/catalog_provider.dart';
import 'package:catalog/catalog/catalog_service.dart';
import 'package:catalog/product/product.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCatalogService extends CatalogService {
  @override
  Future<List<Product>> getProducts() async {
    return [
      Product(
        id: 1,
        title: 'Red Shirt',
        description: 'Nice red shirt',
        price: 20.0,
        category: 'clothes',
        image: 'https://example.com/red-shirt.png',
      ),
      Product(
        id: 2,
        title: 'Blue Jeans',
        description: 'Comfortable jeans',
        price: 40.0,
        category: 'clothes',
        image: 'https://example.com/blue-jeans.png',
      ),
      Product(
        id: 3,
        title: 'iPhone',
        description: 'Smartphone',
        price: 900.0,
        category: 'electronics',
        image: 'https://example.com/iphone.png',
      ),
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    return ['clothes', 'electronics'];
  }
}

void main() {
  group('CatalogNotifier', () {
    late CatalogNotifier notifier;

    setUp(() {
      notifier = CatalogNotifier(FakeCatalogService());
    });

    test('loadProducts loads products and category', () async {
      await notifier.loadProducts();

      final state = notifier.state;

      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.products.length, 3);
      expect(state.categories, ['clothes', 'electronics']);
    });

    test('searController filter products by name', () async {
      await notifier.loadProducts();

      expect(notifier.state.filteredProducts.length, 3);
      notifier.changeSearch('shirt');
      await Future.delayed(const Duration(milliseconds: 450));

      final filtered = notifier.state.filteredProducts;
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Red Shirt');
    });

    test('price sorting: frrom low to high', () async {
      await notifier.loadProducts();

      notifier.changeSort(PriceSort.lowToHigh);
      final filtered = notifier.state.filteredProducts;

      expect(filtered.first.price, 20.0);
      expect(filtered.last.price, 900.0);
    });

    test('price sorting: from high to low', () async {
      await notifier.loadProducts();

      notifier.changeSort(PriceSort.highToLow);
      final filtered = notifier.state.filteredProducts;

      expect(filtered.first.price, 900.0);
      expect(filtered.last.price, 20.0);
    });
  });
}
