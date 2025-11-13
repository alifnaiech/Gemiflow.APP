// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  (json['product_id'] as num).toInt(),
  json['name'] as String?,
  json['sku'] as String?,
  (json['minimum_stock'] as num?)?.toInt(),
  (json['category_id'] as num?)?.toInt(),
  json['category_name'] as String?,
  (json['product_barcodes'] as List<dynamic>)
      .map((e) => ProductBarcodeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'name': instance.name,
      'sku': instance.sku,
      'category_name': instance.category_name,
      'minimum_stock': instance.minimum_stock,
      'category_id': instance.category_id,
      'product_barcodes': instance.product_barcodes,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
