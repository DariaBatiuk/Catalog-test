import 'package:flutter/material.dart';

class Product {
  final int id; 
  final String title; 
  final String description; 
  final double price; 
  final String category; 
  final String image; 

  Product ({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.price, 
    required this.category, 
    required this.image,    
  });

  factory Product.fromJson(
    Map<String, dynamic> json 
  ) {
      return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'],
      category: json['category'] ?? '',
      image: json['image'] ?? '',
    );
    }
}

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}