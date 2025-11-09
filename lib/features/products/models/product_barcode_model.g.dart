// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_barcode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBarcodeModel _$ProductBarcodeModelFromJson(Map<String, dynamic> json) =>
    ProductBarcodeModel(
      (json['barcode_id'] as num).toInt(),
      json['barcode_value'] as String,
      (json['product_id'] as num).toInt(),
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProductBarcodeModelToJson(
  ProductBarcodeModel instance,
) => <String, dynamic>{
  'barcode_id': instance.barcode_id,
  'barcode_value': instance.barcode_value,
  'product_id': instance.product_id,
  'created_at': instance.created_at?.toIso8601String(),
  'updated_at': instance.updated_at?.toIso8601String(),
};
