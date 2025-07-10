import 'dart:convert';

import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';

class EquipmentsModel {
  final int id;
  final String equipmentName;
  final String equipmentImage;
  const EquipmentsModel(
      {required this.id,
      required this.equipmentName,
      required this.equipmentImage});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'equipmentName': equipmentName,
      'equipmentImage': equipmentImage
    };
  }

  factory EquipmentsModel.fromMap(Map<String, dynamic> map) {
    return EquipmentsModel(
        id: map['id'] as int,
        equipmentName: map['equipmentName'] ?? '',
        equipmentImage: map['equipmentImage'] ?? '');
  }
  String toJson() => json.encode(toMap());

  factory EquipmentsModel.fromJson(String source) =>
      EquipmentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension EquipmentsXModel on EquipmentsModel {
  EquipmentsEntity toEntity() {
    return EquipmentsEntity(
        id: id, equipmentName: equipmentName, equipmentImage: equipmentImage);
  }
}
