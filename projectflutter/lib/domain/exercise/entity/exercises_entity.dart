import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';

class ExercisesEntity {
  final int id;
  final String exerciseName;
  final String exerciseImage;
  final String description;
  final int duration;
  final double kcal;
  final ExerciseSubCategoryModel? subCategory;

  ExercisesEntity(
      {required this.id,
      required this.exerciseName,
      required this.exerciseImage,
      required this.description,
      required this.duration,
      required this.kcal,
      required this.subCategory});
}
