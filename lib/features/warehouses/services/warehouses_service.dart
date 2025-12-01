import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemiflow/features/warehouses/models/warehouse_model.dart';
import 'package:gemiflow/shared/models/api_response.dart';
import 'package:http/http.dart' as http_client;

class WarehousesService {
  final String apiUrl = dotenv.env["API_URL"] ?? "";

  ///
  /// Get list of warehouses
  ///
  Future<List<WarehouseModel>> getWarehouses() async {
    final response = await http_client.get(Uri.parse("$apiUrl/Warehouses"));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        decoded,
        (jsonData) => jsonData as List<dynamic>,
      );

      return apiResponse.data.map((e) => WarehouseModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'Errore caricamento lista categorie ${response.statusCode}',
      );
    }
  }

  ///
  /// Create new warehouse
  ///
  Future<void> createWarehouse(String name) async {
    final url = Uri.parse("$apiUrl/Warehouses");
    final body = jsonEncode({'name': name});
    final response = await http_client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Errore durante la creazione della magazzino: ${response.body}',
      );
    }
  }

  ///
  /// Update warehouse
  ///
  Future<void> updateWarehouse(int warehouse_id, String name) async {
    final url = Uri.parse("$apiUrl/Warehouses/$warehouse_id");
    final body = jsonEncode({'warehouse_id': warehouse_id, 'name': name});
    final response = await http_client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 204) {
      throw Exception('Errore durante l\'aggiornamento del magazzino');
    }
  }
}
