import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/products_cateogries/models/products_categories_model.dart';
import 'package:http/http.dart' as http_client;

class ProductsCategoriesService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";

  /// Return list of categories products
  Future<List<ProductsCategory>> getProductsCategories() async{
    final response = await http_client.get(Uri.parse("$apiUrl/ProductsCategory"));
    if (response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ProductsCategory.fromJson(e)).toList();
    }else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
  /// Create new products category
  Future<void> createProductsCategory(String categoryName) async{
    final url = Uri.parse("$apiUrl/ProductsCategory");
    final body = jsonEncode({'name': categoryName});
      final response = await http_client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      print("Error create product category: $response");
      throw Exception('Errore durante la creazione della categoria: ${response.body}');
    }
  }
  
  /// Update product category
  Future<void> updateProductsCategory(int categoryId, String categoryName) async {
    final url = Uri.parse("$apiUrl/ProductsCategory/$categoryId");
    final body = jsonEncode({'productCategoryId': categoryId, 'name': categoryName});
    final response = await http_client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
      );
    if(response.statusCode != 204){
      final resp = response.statusCode;
      print('STATUS_CODE: $resp');
      throw Exception('Errore durante l\'aggiornamento della categoria');
    }  
  }


}