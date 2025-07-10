import 'package:projectflutter/data/exercise/model/equipments_model.dart';

class EquipmentsEntity {
  final int id;
  final String equipmentName;
  final String equipmentImage;
  const EquipmentsEntity(
      {required this.id,
      required this.equipmentName,
      required this.equipmentImage});
  factory EquipmentsEntity.fromModel(EquipmentsModel model) {
    return EquipmentsEntity(
      id: model.id,
      equipmentName: model.equipmentName,
      equipmentImage: model.equipmentImage,
    );
  }
}
