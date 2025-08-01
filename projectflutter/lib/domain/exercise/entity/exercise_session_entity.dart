import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercises_model.dart';

class ExerciseSessionEntity {
  final int id;
  final UserSimpleDTO? user;
  final ExercisesModel? exercise;
  final ExerciseSubCategoryModel? subCategory;
  final double kcal;
  final int resetBatch;
  final int duration;
  final DateTime? createdAt;

  ExerciseSessionEntity(
      {required this.id,
      required this.user,
      required this.exercise,
      required this.subCategory,
      required this.kcal,
      required this.resetBatch,
      required this.duration,
      required this.createdAt});
}
