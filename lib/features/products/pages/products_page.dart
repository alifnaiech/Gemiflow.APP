import 'package:flutter/material.dart';
import 'package:gemiflow/features/products/models/product_model.dart';
import 'package:gemiflow/features/products/repositories/products_repository.dart';
import 'package:gemiflow/features/products/services/products_service.dart';
import 'package:gemiflow/features/categories/models/category_model.dart';
import 'package:gemiflow/features/categories/repositories/categories_repository.dart';
import 'package:gemiflow/features/categories/services/categories_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductsRepository _productsRepository;
  late final CategoriesRepository _categoriesRepository;
  late Future<List<ProductModel>> _futureProducts;
  late Future<List<CategoryModel>> _futureCategory;
  List<CategoryModel> _category = [];
  String euroSymbol = String.fromCharCode(0x20AC);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productsRepository = ProductsRepository(
      productsService: ProductsService(),
    );

    _categoriesRepository = CategoriesRepository(
      categoriesService: CategoriesService(),
    );

    _futureCategory = _categoriesRepository.getCategories();
    _futureCategory.then((category) {
      setState(() {
        _category = category;
      });
    });
    _futureProducts = _productsRepository.getProducts();
  }

  // Add new Product
  Future<void> _openDialogNewProduct() async {
    final TextEditingController productNameCtr = TextEditingController();
    final TextEditingController productStockMinimumQuantityCtr =
        TextEditingController();
    int? selectedCategoryId;
    final result = await showDialog<ProductModel>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuovo Prodotto'),
          content: Form(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800, minWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nome prodotto'),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: productNameCtr,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Categoria'),
                            SizedBox(height: 5),
                            DropdownButtonFormField<int>(
                              initialValue: selectedCategoryId,
                              items: _category.map((cat) {
                                return DropdownMenuItem(
                                  value: cat.category_id,
                                  child: Text(cat.name),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedCategoryId = val;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Scorta minima'),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: productStockMinimumQuantityCtr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final product = ProductModel(
                  0, // or assign a proper id if needed
                  productNameCtr.text,
                  "",
                  int.tryParse(productStockMinimumQuantityCtr.text) ?? 0,
                  selectedCategoryId,
                  [],
                  DateTime.now(),
                  DateTime.now()
                );
                Navigator.pop(context, product);
                print(" Product ${product.toJson()}");
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

    if(result != null ){
      try {
        await _productsRepository.addProduct(result);
        
      } catch (err) {
                if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore: $err'),
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
          "Prodotti",
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
              label: const Text("Nuovo prodotto"),
              onPressed: () {
                _openDialogNewProduct();
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
              child: FutureBuilder(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessun prodotto disponibile'),
                    );
                  }
                  final products = snapshot.data!;
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
                            DataColumn(label: Text('Scorta minima'))
                          ],
                          rows: products.map((product) {
                            return DataRow(
                              cells: [
                                DataCell(Text(product.name)),
                                DataCell(
                                  Text(product.minimum_stock.toString()),
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
