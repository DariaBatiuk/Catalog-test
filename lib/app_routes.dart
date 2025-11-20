import 'package:catalog/cart/cart.dart';
import 'package:catalog/catalog/catalog_screen.dart';
import 'package:catalog/product/product.dart';
import 'package:catalog/product/product_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';
  static const String productDetails = '/product';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const Cart(),
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductScreen(product: product);
        },
      ),
    ],
  );
}
