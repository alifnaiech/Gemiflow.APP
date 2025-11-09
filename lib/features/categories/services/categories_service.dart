import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/categories/models/category_model.dart';
import 'package:gemiflow/shared/models/api_response.dart';
import 'package:http/http.dart' as http_client;

class CategoriesService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";

  /// Return list of categories
  /// TODO: Study dart typing
  Future<List<CategoryModel>> getCategories() async {
    final response = await http_client.get(Uri.parse("$apiUrl/Categories"));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        decoded,
        (jsonData) => jsonData as List<dynamic>,
      );

      return apiResponse.data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Errore caricamento lista categorie ${response.statusCode}',
      );
    }
  }

  /// Create new category
  Future<void> createCategory(String name) async {
    final url = Uri.parse("$apiUrl/Categories");
    final body = jsonEncode({'name': name});
    final response = await http_client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception(
        'Errore durante la creazione della categoria: ${response.body}',
      );
    }
  }

  /// Update category
  Future<void> updateCategory(int category_id, String name) async {
    final url = Uri.parse("$apiUrl/Categories/$category_id");
    final body = jsonEncode({'category_id': category_id, 'name': name});
    final response = await http_client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 204) {
      throw Exception('Errore durante l\'aggiornamento della categoria');
    }
  }
}
