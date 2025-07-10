import 'package:projectflutter/data/exercise/model/equipments_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';

class ExercisesEntity {
  final int id;
  final String exerciseName;
  final String exerciseImage;
  final String description;
  final int duration;
  final double kcal;
  final List<ExerciseSubCategoryModel> subCategory;
  final EquipmentsModel? equipment;
  final ExerciseModeModel? mode;

  ExercisesEntity({
    required this.id,
    required this.exerciseName,
    required this.exerciseImage,
    required this.description,
    required this.duration,
    required this.kcal,
    required this.subCategory,
    required this.equipment,
    required this.mode,
  });
}
