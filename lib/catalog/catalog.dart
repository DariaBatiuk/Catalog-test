import 'package:catalog/app.components/app_bottom_navigation_bat.dart';
import 'package:flutter/material.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _catalogState();
}

class _catalogState extends State<Catalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: itemBuilder)),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}