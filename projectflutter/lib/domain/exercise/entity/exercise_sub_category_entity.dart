import 'package:projectflutter/data/exercise/model/exercise_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_favorite_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_programs_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_schedule_model.dart';

class ExerciseSubCategoryEntity {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final List<ExerciseCategoryModel> category;

  ExerciseSubCategoryEntity({
    required this.id,
    required this.subCategoryName,
    required this.subCategoryImage,
    required this.description,
    required this.category
  });
}
