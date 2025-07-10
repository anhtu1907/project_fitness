import 'package:projectflutter/data/exercise/model/exercise_programs_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';

class ExerciseSubCategoryProgramEntity {
  final int id;
  final ExerciseSubCategoryModel? subCategory;
  final ExerciseProgramsModel? program;
  const ExerciseSubCategoryProgramEntity(
      {required this.id, required this.subCategory, required this.program});
}
