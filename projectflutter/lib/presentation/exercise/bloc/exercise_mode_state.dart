import 'package:projectflutter/domain/exercise/entity/exercise_mode_entity.dart';

abstract class ExerciseModeState{}

class ExerciseModeLoading extends ExerciseModeState{}

class ExerciseModeLoaded extends ExerciseModeState{
  List<ExerciseModeEntity> entity;
  ExerciseModeLoaded({required this.entity});
}

class LoadExerciseModeFailure extends ExerciseModeState{
  final String errorMessage;
  LoadExerciseModeFailure({required this.errorMessage});
}