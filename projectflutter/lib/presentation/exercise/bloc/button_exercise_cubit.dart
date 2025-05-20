import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
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

  Future<void> setResetBatchBySubCategory(int subCategoryId, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("reset_batch_subCategory_$subCategoryId", value);
  }

  Future<void> checkExerciseState(int subCategoryId) async {
    emit(ButtonLoading());
    var result = await sl<GetExerciseProgressUseCase>().call();
    final resetBatch = await getResetBatchBySubCategory(subCategoryId);
    result.fold((err) {
      emit(ButtonInitialize());
      print(err);
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
        final progress = last.progress;
        final maxBatch = filteredData
            .map((e) => e.exercise!.resetBatch)
            .fold<int>(0, (a, b) => a > b ? a : b);
        final latestBatchData = filteredData
            .where((e) => e.exercise!.resetBatch == maxBatch)
            .toList();
        final allCompleted = latestBatchData.any((e) => e.progress == 100);
        final hasIncomplete = latestBatchData.any((e) => e.progress < 100);
        if (allCompleted) {
          emit(ButtonRestart());
        } else if (hasIncomplete) {
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
      int? subCategoryId = exercises.first.subCategory!.id;
      final resetBatch = await getResetBatchBySubCategory(subCategoryId);
      print('Reset Batch: $resetBatch');
      final exerciseIds = (progressList as List<ExerciseProgressEntity>)
          .where((e) =>
              e.exercise!.exercise!.subCategory!.id == subCategoryId &&
              e.exercise!.resetBatch == resetBatch &&
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

  Future<void> incrementResetBatch(int subCategoryId) async {
    final resetBatch = await getResetBatchBySubCategory(subCategoryId);
    final newBatch = resetBatch! + 1;
    await setResetBatchBySubCategory(subCategoryId, newBatch);
  }

  int getResetBatch() => resetBatch;
}
