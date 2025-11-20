import 'package:catalog/catalog/catalog_screen.dart';
import 'package:catalog/cart/cart_screeen.dart';
import 'package:catalog/product/product.dart';
import 'package:catalog/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';
  static const String product = '/product';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: home,
        builder: (_, __) => const CatalogScreen(),
      ),
      GoRoute(
        path: cart,
        builder: (_, __) => const CartScreen(),          
      ),
      GoRoute(
        path: product,
        builder: (_, state) {
          final product = state.extra as Product;
          return ProductScreen(product: product);
        },
      ),
    ],
  );
}

