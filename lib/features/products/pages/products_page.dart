import 'package:flutter/material.dart';
import 'package:gemiflow/features/products/models/product_model.dart';
import 'package:gemiflow/features/products/repositories/products_repository.dart';
import 'package:gemiflow/features/products/services/products_service.dart';
import 'package:gemiflow/features/products_categories/models/products_categories_model.dart';
import 'package:gemiflow/features/products_categories/repositories/products_categories_repository.dart';
import 'package:gemiflow/features/products_categories/services/products_categories_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductsRepository _productsRepository;
  late final ProductsCategoriesRepository _productsCategoriesRepository;
  late Future<List<Product>> _futureProducts;
  late Future<List<ProductsCategory>> _futureProductsCategory;
  List<ProductsCategory> _productsCategory = [];
  String euroSymbol = String.fromCharCode(0x20AC);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productsRepository = ProductsRepository(
      productsService: ProductsService(),
    );

    _productsCategoriesRepository = ProductsCategoriesRepository(
      productsCategoriesService: ProductsCategoriesService(),
    );

    _futureProductsCategory = _productsCategoriesRepository
        .getProductsCategories();
    _futureProductsCategory.then((productsCategory) {
      setState(() {
        _productsCategory = productsCategory;
      });
    });
    _futureProducts = _productsRepository.getProducts();
  }

  // Add new Product
  Future<void> _openDialogNewProduct() async {
    final TextEditingController productNameCtr = TextEditingController();
    final TextEditingController productStockQuantityCtr =
        TextEditingController();
    final TextEditingController productStockMinimumQuantityCtr =
        TextEditingController();
    final TextEditingController productPricePurchaseCtr =
        TextEditingController();
    final TextEditingController productPriceSaleCtr = TextEditingController();
    final TextEditingController productBarcodeNumberCtr =
        TextEditingController();
    int? selectedProductCategoryId;
    final result = await showDialog(
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
                              initialValue: selectedProductCategoryId,
                              items: _productsCategory.map((prodCat) {
                                return DropdownMenuItem(
                                  value: prodCat.productCategoryId,
                                  child: Text(prodCat.name),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedProductCategoryId = val;
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
                  const Text('Codice a barre'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: productBarcodeNumberCtr,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quantità'),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: productStockQuantityCtr,
                              decoration: InputDecoration(
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prezzo Acquisto ($euroSymbol)'),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: productPricePurchaseCtr,
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
                            Text('Prezzo Vendita ($euroSymbol)'),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: productPriceSaleCtr,
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
                print("Selected category id ${selectedProductCategoryId}");
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
                            DataColumn(label: Text('Quantità')),
                            DataColumn(label: Text('Stato')),
                          ],
                          rows: products.map((product) {
                            return DataRow(
                              cells: [
                                DataCell(Text(product.name)),
                                DataCell(
                                  Text(product.stockQuantity.toString()),
                                ),
                                DataCell(Text('Stato')),
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
