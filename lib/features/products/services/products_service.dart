import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/products/models/product_model.dart';
import 'package:http/http.dart' as http_client;

class ProductsService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";

  Future<List<Product>> getProducts() async {
    final response = await http_client.get(Uri.parse("$apiUrl/Products"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
