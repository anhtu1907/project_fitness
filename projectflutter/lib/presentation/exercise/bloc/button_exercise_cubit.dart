import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_progress.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_state.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonExerciseCubit extends Cubit<ButtonExerciseState> {
  ButtonExerciseCubit() : super(ButtonInitialize());

  Future<void> checkExerciseState(int subCategoryId) async {
    emit(ButtonLoading());
    var result = await sl<GetExerciseProgressUseCase>().call();
    final prefs = await SharedPreferences.getInstance();
    var reset = prefs.getInt('reset_batch');
    result.fold((err) {
      emit(ButtonInitialize());
    }, (data) {
      if (data is List<ExerciseProgressEntity> && data.isNotEmpty) {
        final filteredData = data
            .where((progress) =>
                progress.exercise!.exercise!.subCategory!.id == subCategoryId)
            .toList();
        if (filteredData.isEmpty) {
          emit(ButtonInitialize());
          return;
        }
        final last = filteredData.last;
        final resetBatch = reset;
        final progress = last.progress;
        if (resetBatch == 0 && progress == 100) {
          emit(ButtonRestart());
          reset = reset! + 1;
        } else if (progress < 100) {
          emit(ButtonContinue());
        } else {
          emit(ButtonInitialize());
        }
      } else {
        emit(ButtonInitialize());
      }
    });
  }

  Future<int?> getNextExerciseIndex(List<ExercisesEntity> exercises) async {
    var reuslt = await sl<GetExerciseProgressUseCase>().call();
    return await reuslt.fold((err) {
      return err;
    }, (progressList) async {
      int? categoryId = exercises.first.subCategory!.id;

      final exerciseIds = (progressList as List<ExerciseProgressEntity>)
          .where((e) =>
              e.exercise!.exercise!.subCategory!.id == categoryId &&
              e.exercise!.exercise != null)
          .map((e) => e.exercise!.exercise!.id)
          .toList();
      final uncompletedExercises =
          exercises.where((e) => !exerciseIds.contains(e.id));
      if (uncompletedExercises.isNotEmpty) {
        final nextExercise = uncompletedExercises.first;
        final currentIndex =
            exercises.indexWhere((e) => e.id == nextExercise.id);
        return currentIndex;
      } else {
        return null;
      }
    });
  }
}
