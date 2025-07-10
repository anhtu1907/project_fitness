
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';

abstract class ExerciseSubCategoryProgramState {}

class SubCategoryProgramLoading extends ExerciseSubCategoryProgramState {}

class SubCategoryProgramLoaded extends ExerciseSubCategoryProgramState {
  final List<ExerciseSubCategoryProgramEntity> entity;

  SubCategoryProgramLoaded({required this.entity});
}

class LoadSubCategoryProgramFailure extends ExerciseSubCategoryProgramState {
  final String errorMessage;

  LoadSubCategoryProgramFailure({required this.errorMessage});
}
