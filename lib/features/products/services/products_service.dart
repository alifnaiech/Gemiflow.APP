import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/products/models/product_model.dart';
import 'package:gemiflow/shared/models/api_response.dart';
import 'package:http/http.dart' as http_client;

class ProductsService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";

  Future<List<ProductModel>> getProducts() async {
    final response = await http_client.get(Uri.parse("$apiUrl/products"));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        decoded,
        (jsonData) => jsonData as List<dynamic>,
      );

      return apiResponse.data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<void> createProduct(ProductModel product) async {
    final url = Uri.parse("$apiUrl/products");
    final body = jsonEncode({'name': product.name, 'sku': '', 'category_id': product.category_id, 'minimum_stock': product.minimum_stock});
    print('${body}');
    final response = await http_client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 200) {
      print('${response.body}');
      throw Exception(
        'Errore durante la creazione della categoria: ${response.body}',
      );
    }
  }
}
