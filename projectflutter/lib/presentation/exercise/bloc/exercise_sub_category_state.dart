import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';

abstract class ExerciseSubCategoryState {}

class SubCategoryLoading extends ExerciseSubCategoryState {}

class SubCategoryLoaded extends ExerciseSubCategoryState {
  final List<ExerciseSubCategoryEntity> entity;

  SubCategoryLoaded({required this.entity});
}

class LoadSubCategoryFailure extends ExerciseSubCategoryState {
  final String errorMessage;

  LoadSubCategoryFailure({required this.errorMessage});
}
