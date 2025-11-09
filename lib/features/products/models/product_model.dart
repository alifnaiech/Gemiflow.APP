import 'package:gemiflow/features/products/models/product_barcode_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  int product_id;
  String name;
  String sku_code;
  int? minimum_stock;
  int? category_id;
  List<ProductBarcodeModel> product_barcodes;
  DateTime? created_at;
  DateTime? updated_at;

  ProductModel(
    this.product_id,
    this.name,
    this.sku_code,
    this.minimum_stock,
    this.category_id,
    this.product_barcodes,
    this.created_at,
    this.updated_at,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
