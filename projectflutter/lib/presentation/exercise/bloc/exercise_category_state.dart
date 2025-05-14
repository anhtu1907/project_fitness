import 'package:projectflutter/domain/exercise/entity/exercise_category_entity.dart';

abstract class ExerciseCategoryState {}

class ExerciseCategoryLoading extends ExerciseCategoryState {}

class ExerciseCategoryLoaded extends ExerciseCategoryState {
  List<ExerciseCategoryEntity> entity;
  ExerciseCategoryLoaded({required this.entity});
}

class LoadExerciseCategoryFailure extends ExerciseCategoryState {
  final String errorMessage;
  LoadExerciseCategoryFailure({required this.errorMessage});
}
