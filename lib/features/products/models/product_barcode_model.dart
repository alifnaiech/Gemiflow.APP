import 'package:json_annotation/json_annotation.dart';

part 'product_barcode_model.g.dart';

@JsonSerializable()
class ProductBarcodeModel {
  final int barcode_id;
  final String barcode_value;
  final int product_id;
  final DateTime? created_at;
  final DateTime? updated_at;

  ProductBarcodeModel(
    this.barcode_id,
    this.barcode_value,
    this.product_id,
    this.created_at,
    this.updated_at,
  );

  factory ProductBarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBarcodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBarcodeModelToJson(this);
}
