import 'package:gemiflow/features/categories/models/category_model.dart';
import 'package:gemiflow/features/categories/services/categories_service.dart';

class CategoriesRepository {
  final CategoriesService categoriesService;

  CategoriesRepository({required this.categoriesService});

  Future<List<CategoryModel>> getCategories() async {
    try {
      final productsCategories = await categoriesService
          .getCategories();
      return productsCategories;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCategory(String name) async {
    await categoriesService.createCategory(name);
  }

  Future<void> updateCategory(int category_id, String name) async{
    await categoriesService.updateCategory(category_id, name);
  }
}