import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';

class ExerciseSubCategoryModeMapping {
  final int subCategoryId;
  final ExerciseModeModel mode;

  ExerciseSubCategoryModeMapping({
    required this.subCategoryId,
    required this.mode,
  });
  factory ExerciseSubCategoryModeMapping.fromMap(Map<String, dynamic> map) {
    return ExerciseSubCategoryModeMapping(
      subCategoryId: map['subCategoryId'] as int,
      mode: ExerciseModeModel.fromMap(map['mode']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subCategoryId': subCategoryId,
      'mode': mode.toMap(),
    };
  }
}
