import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';

abstract class ExerciseListSubCategoryState {}

class ListSubCategoryLoading extends ExerciseListSubCategoryState {}

class ListSubCategoryLoaded extends ExerciseListSubCategoryState {
  final List<ExerciseSubCategoryEntity> entity;

  ListSubCategoryLoaded({required this.entity});
}

class LoadListSubCategoryFailure extends ExerciseListSubCategoryState {
  final String errorMessage;

  LoadListSubCategoryFailure({required this.errorMessage});
}
