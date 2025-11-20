import 'package:catalog/cart/cart.dart';
import 'package:catalog/catalog/catalog.dart';
import 'package:catalog/product/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: home, builder: (context, state) => const Catalog()),
      
      GoRoute(
        path: cart,
        builder: (context, state) => const Cart(),
      ),
    ],
  );
}
