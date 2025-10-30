import 'package:flutter/material.dart';
import 'package:gemiflow/features/products_cateogries/models/products_categories_model.dart';
import 'package:gemiflow/features/products_cateogries/repositories/products_categories_repository.dart';
import 'package:gemiflow/features/products_cateogries/services/products_categories_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categorie")),
      body: FutureBuilder<List<ProductsCategory>>(
        future: _futureProductsCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessun categoria disponibile'));
          }

          final productsCategory = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [DataColumn(label: Text('Nome'))],
              rows: productsCategory.map((p) {
                return DataRow(cells: [DataCell(Text(p.name))]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
