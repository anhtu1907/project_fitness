import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

abstract class ExercisesState {}

class ExercisesLoading extends ExercisesState {}

class ExercisesLoaded extends ExercisesState {
  final List<ExercisesEntity> entity;

  ExercisesLoaded({required this.entity});
}

class LoadExercisesFailure extends ExercisesState {
  final String errorMessage;

  LoadExercisesFailure({required this.errorMessage});
}
