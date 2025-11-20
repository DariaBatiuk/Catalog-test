import 'package:catalog/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if(index == 0) {
          context.go(AppRoutes.home);
        }
        if(index == 1){
          context.go(AppRoutes.cart);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), 
          activeIcon: Icon(Icons.home), 
          label: "Home"),
        
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined), 
          activeIcon: Icon(Icons.shopping_cart),
          label: "Cart")
      ],

    );
  }
}