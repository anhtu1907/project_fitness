import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';


abstract class ExerciseEquipmentState{}

class ExerciseEquipmentLoading extends ExerciseEquipmentState{}

class ExerciseEquipmentLoaded extends ExerciseEquipmentState{
  List<EquipmentsEntity> entity;
  ExerciseEquipmentLoaded({required this.entity});
}

class LoadExerciseEquipmentFailure extends ExerciseEquipmentState{
  final String errorMessage;
  LoadExerciseEquipmentFailure({required this.errorMessage});
}