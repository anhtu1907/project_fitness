import 'package:projectflutter/domain/exercise/entity/exercise_favorite_entity.dart';

abstract class ExerciseFavoriteState{}

class ExerciseFavoriteLoading extends ExerciseFavoriteState{}

class ExerciseFavoriteLoaded extends ExerciseFavoriteState{
  List<ExerciseFavoriteEntity> entity;
ExerciseFavoriteLoaded({required this.entity});
}

class LoadExerciseFavoriteFailure extends ExerciseFavoriteState{
  final String errorMessage;
  LoadExerciseFavoriteFailure({required this.errorMessage});
}