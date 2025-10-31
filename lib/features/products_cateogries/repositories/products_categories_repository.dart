import 'package:gemiflow/features/products_cateogries/models/products_categories_model.dart';
import 'package:gemiflow/features/products_cateogries/services/products_categories_service.dart';

class ProductsCategoriesRepository {
  final ProductsCategoriesService productsCategoriesService;

  ProductsCategoriesRepository({required this.productsCategoriesService});

  Future<List<ProductsCategory>> getProductsCategories() async {
    try {
      final productsCategories = await productsCategoriesService
          .getProductsCategories();
      return productsCategories;
    } catch (e) {
      print("Error in the repository ");
      rethrow;
    }
  }

  Future<void> addCategory(String name) async {
    await productsCategoriesService.createProductsCategory(name);
  }

  Future<void> updateCategory(int categoryId, String categoryName) async{
    await productsCategoriesService.updateProductsCategory(categoryId, categoryName);
  }
}
