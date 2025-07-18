import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/exercise/request/exercise_favorite_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_batch_request.dart';

abstract class ExerciseRepository {
  // Exercise
  Future<Either> getExerciseBySubCategory(int subCategoryId);
  Future<Either> getExerciseById(int exerciseId);
  Future<Either> getAllSubCategory();
  Future<Either> startMultipleExercises(ExerciseSessionBatchRequest req);
  Future<Either> getAllExercise();
  Future<Either> getAllCategory();
  Future<int?> getResetBatchBySubCategory(int subCategoryId);
  // Schedule
  Future<Either> scheduleExercise(ExerciseScheduleRequest req);
  Future<Either> getAllExerciseScheduleByUserId();
  Future<void> deleteExerciseSchdedule(int scheduleId);
  Future<void> deleteAllExerciseScheduleByTime();
  // Result
  Future<Either> getAllExerciseProgressByUserId();
  Future<Either> getAllExerciseSessionByUserId();
  Future<Either> getAllExerciseResultByUserId();
  // Favorite
  Future<Either> getAllFavorite();
  Future<Either> getAllExerciseFavorite(int favoriteId);
  Future<Either> addNewFavoriteByUserId(String favoriteName);
  Future<Either> addExerciseFavoriteByUserId(ExerciseFavoriteRequest req);
  Future<void> removeFavorite(int favoriteId);
  Future<void> removeExerciseFavorite(int subCategoryId);

  // SubCategory-Program
  Future<Either> getAllSubCategoryProgram();

  // Exercise Mode
  Future<Either> getAllExerciseMode();

  // Search
  Future<Either> searchBySubCategoryName(String subCategoryName);

  // Equipment
  Future<Either> getAllEquipment();
  // Future<Either> getAllExerciseEquipment();
  Future<Either> getAllEquipmentBySubCategoryId(int subCategoryId);
}
