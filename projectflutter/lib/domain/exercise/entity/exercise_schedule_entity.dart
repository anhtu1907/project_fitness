import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';

class ExerciseScheduleEntity {
  final int id;
  final UserSimpleDTO? user;
  final ExerciseSubCategoryModel? subCategory;
  final DateTime? scheduleTime;

  ExerciseScheduleEntity(
      {required this.id,
      required this.user,
      required this.subCategory,
      required this.scheduleTime});
}
