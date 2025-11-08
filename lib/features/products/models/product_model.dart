import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  int productId;
  String name;
  String description;
  double? pricePurchase;
  double? priceSale;
  int? barcodeNumber;
  String skuCode;
  int? stockQuantity;
  int? stockMinimumQuantity;
  int? categoryId;
  String imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Product(
    this.productId,
    this.name,
    this.description,
    this.pricePurchase,
    this.priceSale,
    this.barcodeNumber,
    this.skuCode,
    this.stockQuantity,
    this.stockMinimumQuantity,
    this.categoryId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  );

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
