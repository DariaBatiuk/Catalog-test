import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catalog/product/product.dart';

class CatalogService {
  final String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$_baseUrl/products');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load products. Error: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final url = Uri.parse('$_baseUrl/products/categories');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load categories. Error: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<String>();
  }
}

