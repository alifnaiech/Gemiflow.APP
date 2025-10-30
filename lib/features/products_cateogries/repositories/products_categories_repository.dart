import 'package:gemiflow/features/products_cateogries/models/products_categories_model.dart';
import 'package:gemiflow/features/products_cateogries/services/products_categories_service.dart';

class ProductsCategoriesRepository {
  final ProductsCategoriesService productsCategoriesService;

  ProductsCategoriesRepository({required this.productsCategoriesService});

  Future<List<ProductsCategory>> getProductsCategories() async {
    try {
      final productsCategories = await productsCategoriesService.getProductsCategories();
      return productsCategories;
    } catch (e) {
      print("Error in the repository ");
      rethrow;
    }
  }
}
