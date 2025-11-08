import 'package:flutter/material.dart';
import 'package:gemiflow/features/products_categories/models/products_categories_model.dart';
import 'package:gemiflow/features/products_categories/repositories/products_categories_repository.dart';
import 'package:gemiflow/features/products_categories/services/products_categories_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final ProductsCategoriesRepository _productsCategoriesRepository;
  late Future<List<ProductsCategory>> _futureProductsCategory;

  @override
  void initState() {
    super.initState();
    _productsCategoriesRepository = ProductsCategoriesRepository(
      productsCategoriesService: ProductsCategoriesService(),
    );
    _futureProductsCategory = _productsCategoriesRepository
        .getProductsCategories();
  }

  void _loadProductsCategories() {
    setState(() {
      _futureProductsCategory = _productsCategoriesRepository
          .getProductsCategories();
    });
  }

  /// Add new Product Category
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
          title: const Text('Nuova Categoria'),
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
      try {
        await _productsCategoriesRepository.addCategory(result);
        _loadProductsCategories();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Categoria aggiunta'),
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

  /// Edit Product Category
  Future<void> _openEditDialog(
    BuildContext context,
    ProductsCategory productCategory,
  ) async {
    final result = await showDialog<ProductsCategory>(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController(
          text: productCategory.name,
        );
        return AlertDialog(
          title: Text('Modifica categoria'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (value) {
              productCategory.name = nameController.text.trim();
              Navigator.pop(context, productCategory);
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
                productCategory.name = nameController.text.trim();
                Navigator.pop(context, productCategory);
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
        await _productsCategoriesRepository.updateCategory(
          result.productCategoryId,
          result.name,
        );
        _loadProductsCategories();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoria aggiornata con successo'),
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
          "Categorie",
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
              label: const Text("Nuova categoria"),
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
              child: FutureBuilder<List<ProductsCategory>>(
                future: _futureProductsCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessun categoria disponibile'),
                    );
                  }

                  final productsCategory = snapshot.data!;

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
                          rows: productsCategory.map((productCategory) {
                            return DataRow(
                              cells: [
                                DataCell(Text(productCategory.name)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _openEditDialog(context, productCategory);
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
