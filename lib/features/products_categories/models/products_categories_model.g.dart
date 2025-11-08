// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsCategory _$ProductsCategoryFromJson(Map<String, dynamic> json) =>
    ProductsCategory(
      (json['productCategoryId'] as num).toInt(),
      json['name'] as String,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductsCategoryToJson(ProductsCategory instance) =>
    <String, dynamic>{
      'productCategoryId': instance.productCategoryId,
      'name': instance.name,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
