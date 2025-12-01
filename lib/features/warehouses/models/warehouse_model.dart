import 'package:json_annotation/json_annotation.dart';

part 'warehouse_model.g.dart';

@JsonSerializable()
class WarehouseModel {
  int warehouse_id;
  String name;
  DateTime? created_at;
  DateTime? updated_at;

  WarehouseModel(
    this.warehouse_id,
    this.name,
    this.created_at,
    this.updated_at,
  );

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => _$WarehouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}
