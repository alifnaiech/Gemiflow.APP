import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/products_cateogries/models/products_categories_model.dart';
import 'package:http/http.dart' as http_client;

class ProductsCategoriesService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";


  Future<List<ProductsCategory>> getProductsCategories() async{
    final response = await http_client.get(Uri.parse("$apiUrl/ProductsCategory"));
    if (response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ProductsCategory.fromJson(e)).toList();
    }else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
    
  }

}