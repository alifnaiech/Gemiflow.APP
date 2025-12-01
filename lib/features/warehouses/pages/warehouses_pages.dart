import 'package:flutter/material.dart';
import 'package:gemiflow/features/warehouses/models/warehouse_model.dart';
import 'package:gemiflow/features/warehouses/repositories/warehouses_repository.dart';
import 'package:gemiflow/features/warehouses/services/warehouses_service.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  late final WarehousesRepository _warehousesRepository;
  late Future<List<WarehouseModel>> _futureWarehouse;

  @override
  void initState() {
    super.initState();
    _warehousesRepository = WarehousesRepository(
      warehousesService: WarehousesService()
    );
    _futureWarehouse = _warehousesRepository.getWarehouses();
  }

  void _loadWarehouses() {
    setState(() {
      _futureWarehouse = _warehousesRepository.getWarehouses();
    });
  }

  /// Add new Warehouse
  Future<void> _openDialog(BuildContext context) async {
    // showDialog returns a Future that completes when Navigator.pop is called inside the dialog
    final result = await showDialog<String>(
      context: context,
      barrierDismissible:
          true, // tap outside to dismiss? set false to force explicit buttons
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        // Simple AlertDialog with two buttons
        return AlertDialog(
          title: const Text('Nuovo Magazzino'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final text = nameController.text.trim();
                // Close dialog and return true
                Navigator.pop(context, text);
              },
              child: const Text('Salva'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog and return false
                Navigator.pop(context);
              },
              child: const Text('Annula'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      print(result);
      try {
        await _warehousesRepository.addWarehouse(result);
        _loadWarehouses();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Magazzino aggiunto'),
              backgroundColor: Colors.teal,
            ),
          );
        }
      } catch (exp) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore: $exp'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      // later we’ll call your repository here to save it
    }
  }

  /// Edit Warehouse
  Future<void> _openEditDialog(
    BuildContext context,
    WarehouseModel warehouse,
  ) async {
    final result = await showDialog<WarehouseModel>(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController(
          text: warehouse.name,
        );
        return AlertDialog(
          title: Text('Modifica magazzino'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (value) {
              warehouse.name = nameController.text.trim();
              Navigator.pop(context, warehouse);
            },
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                warehouse.name = nameController.text.trim();
                Navigator.pop(context, warehouse);
              },
              child: const Text('Salva'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );

    if (result != null && result.name.isNotEmpty) {
      try {
        await _warehousesRepository.updateWarehouse(
          result.warehouse_id,
          result.name,
        );
        _loadWarehouses();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Magazzino aggiornato con successo'),
              backgroundColor: Colors.teal,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore durante aggiornamento: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Magazzino",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: const Text("Nuovo Magazzino"),
              onPressed: () {
                _openDialog(context);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<WarehouseModel>>(
                future: _futureWarehouse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessun magazzino disponibile'),
                    );
                  }

                  final warehouses = snapshot.data!;

                  return SafeArea(
                    child: SizedBox.expand(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey[100],
                          ),
                          columns: const [
                            DataColumn(label: Text('Nome')),
                            DataColumn(label: Text('Azioni')),
                          ],
                          rows: warehouses.map((wrh) {
                            return DataRow(
                              cells: [
                                DataCell(Text(wrh.name)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _openEditDialog(context, wrh);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
