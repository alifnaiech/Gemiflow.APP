// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  (json['productId'] as num).toInt(),
  json['name'] as String,
  json['description'] as String,
  (json['pricePurchase'] as num?)?.toDouble(),
  (json['priceSale'] as num?)?.toDouble(),
  (json['barcodeNumber'] as num?)?.toInt(),
  json['skuCode'] as String,
  (json['stockQuantity'] as num?)?.toInt(),
  (json['stockMinimumQuantity'] as num?)?.toInt(),
  (json['categoryId'] as num?)?.toInt(),
  json['imageUrl'] as String,
  json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'productId': instance.productId,
  'name': instance.name,
  'description': instance.description,
  'pricePurchase': instance.pricePurchase,
  'priceSale': instance.priceSale,
  'barcodeNumber': instance.barcodeNumber,
  'skuCode': instance.skuCode,
  'stockQuantity': instance.stockQuantity,
  'stockMinimumQuantity': instance.stockMinimumQuantity,
  'categoryId': instance.categoryId,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
