import 'package:projectflutter/data/exercise/model/exercise_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';

class ExerciseSubCategoryEntity {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final ExerciseCategoryModel? category;
  final ExerciseModeModel? mode;

  ExerciseSubCategoryEntity(
      {required this.id,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.description,
      required this.category,
      required this.mode});
}
