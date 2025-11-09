import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel{
  int category_id;
  String name;
  String? description;
  DateTime? created_at;
  DateTime? updated_at;
  CategoryModel(
    this.category_id,
    this.description,
    this.name,
    this.created_at,
    this.updated_at,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}