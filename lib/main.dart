import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalog/app_routes.dart';
import 'package:catalog/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData().light(),
      darkTheme: AppThemeData().dark(),
      title: 'Catalog',
      routerConfig: AppRoutes.router,
    );
  }
}

