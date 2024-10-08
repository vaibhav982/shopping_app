import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/main.dart';

import '../../models/product.dart';

class ProductData {
  final List<Product> products;
  final String? nextCursor;

  ProductData(this.products, this.nextCursor);
}

class ProductRepository {
  Future<ProductData> fetchProducts({String? cursor}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/products?limit=20${cursor != null ? '&cursor=$cursor' : ''}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Product> products = (data['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      return ProductData(products, data['nextCursor']);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchRecommendedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/recommended-products'));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load recommended products');
    }
  }
}
