import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';

abstract class EquipmentState {}

class EquipmentLoading extends EquipmentState {}

class EquipmentLoaded extends EquipmentState {
  List<EquipmentsEntity> entity;
  EquipmentLoaded({required this.entity});
}

class LoadEquipmentFailure extends EquipmentState {
  final String errorMessage;
  LoadEquipmentFailure({required this.errorMessage});
}
