import 'dart:convert';

import 'package:catalog/product/product.dart';
import 'package:http/http.dart' as http;

class Api{
  final _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$_baseUrl/products');

    try{
      final response = await http.get(url);
      if(response.statusCode != 200) {
        throw Exception('Failed to load products. Error: ${response.statusCode}');
      }

      final List<dynamic> results = jsonDecode(response.body) as List<dynamic>;

      return results
        .map((product) => Product.fromJson(product as Map<String, dynamic>))
        .toList();

    } catch(error){
      throw Exception('Loading is failed: $error');
    }
  }

}