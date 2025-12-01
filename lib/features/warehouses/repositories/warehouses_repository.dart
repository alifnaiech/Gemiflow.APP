import 'package:gemiflow/features/warehouses/models/warehouse_model.dart';
import 'package:gemiflow/features/warehouses/services/warehouses_service.dart';

class WarehousesRepository {
  final WarehousesService warehousesService;
  WarehousesRepository({required this.warehousesService});

  Future<List<WarehouseModel>> getWarehouses() async {
    return await warehousesService.getWarehouses();
  }

  Future<void> addWarehouse(String name) async {
    await warehousesService.createWarehouse(name);
  }

  Future<void> updateWarehouse(int warehouse_id, String name) async {
    await warehousesService.updateWarehouse(warehouse_id, name);
  }
}
