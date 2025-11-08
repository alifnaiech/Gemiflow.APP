import 'package:gemiflow/features/products/services/products_service.dart';
import 'package:gemiflow/features/products/models/product_model.dart';

class ProductsRepository {
  final ProductsService productsService;

  ProductsRepository({required this.productsService});
  ///? TODO: Understand the using of rethrow
  Future<List<Product>> getProducts() async {
    try {
      final products = await productsService.getProducts();
      return products;
    } catch (e) {
      print("Error in the get products repository ");
      rethrow;
    }
  }
}
