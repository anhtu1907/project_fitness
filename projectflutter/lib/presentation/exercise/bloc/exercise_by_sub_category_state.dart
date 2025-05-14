// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

abstract class ExerciseBySubCategoryState {}

class ExerciseBySubCategoryLoading extends ExerciseBySubCategoryState {}

class ExerciseBySubCategoryLoaded extends ExerciseBySubCategoryState {
  List<ExercisesEntity> entity;
  ExerciseBySubCategoryLoaded({
    required this.entity,
  });
}

class LoadExerciseBySubCategoryFailure extends ExerciseBySubCategoryState {
  final String errorMessage;
  LoadExerciseBySubCategoryFailure({required this.errorMessage});
}
