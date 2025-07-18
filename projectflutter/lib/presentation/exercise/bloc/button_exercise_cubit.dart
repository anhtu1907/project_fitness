import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_progress.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_state.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonExerciseCubit extends Cubit<ButtonExerciseState> {
  int resetBatch = 0;
  ButtonExerciseCubit() : super(ButtonInitialize());

  Future<int?> getResetBatchBySubCategory(int subCategoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt("reset_batch_subCategory_$subCategoryId");
    if (value == null) {
      resetBatch = 0;
    } else {
      resetBatch = value;
    }
    return resetBatch;
  }
  Future<bool> hasProgress(int subCategoryId) async {
    final result = await sl<GetExerciseProgressUseCase>().call();
    return result.fold((err) => false, (data) {
      if (data is List<ExerciseProgressEntity>) {
        return data.any((progress) =>
        progress.session?.subCategory?.id == subCategoryId);
      }
      return false;
    });
  }

  Future<void> setResetBatchBySubCategory(int subCategoryId, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("reset_batch_subCategory_$subCategoryId", value);
  }


}
