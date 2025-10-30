import 'package:json_annotation/json_annotation.dart';

part 'products_categories_model.g.dart';

@JsonSerializable()
class ProductsCategory {
  int productCategoryId;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductsCategory(
    this.productCategoryId,
    this.name,
    this.createdAt,
    this.updatedAt,
  );

  factory ProductsCategory.fromJson(Map<String, dynamic> json) =>  _$ProductsCategoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProductsCategoryToJson(this);
}
