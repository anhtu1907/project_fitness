import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/exercise/model/exercise_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_favorite_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_progress_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_schedule_model.dart';
import 'package:projectflutter/data/exercise/model/favorites_model.dart';
import 'package:projectflutter/data/exercise/request/exercise_favorite_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_user_model.dart';
import 'package:projectflutter/data/exercise/model/exercises_model.dart';
import 'package:projectflutter/data/exercise/source/exercise_service.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_favorite_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_schedule_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_session_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/domain/exercise/entity/favorites_entity.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseRepositoryImpl extends ExerciseRepository {

  // Exercise
  @override
  Future<Either> getAllSubCategory() async {
    var subCategory = await sl<ExerciseService>().getAllSubCategory();
    return subCategory.fold((err) {
      return Left(err);
    }, (data) {
      List<ExerciseSubCategoryModel> models = (data as List)
          .map((e) => ExerciseSubCategoryModel.fromMap(e))
          .toList();
      List<ExerciseSubCategoryEntity> entities =
          models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getExerciseBySubCategory(int subCategoryId) async {
    var mealByCategory =
        await sl<ExerciseService>().getExerciseBySubCategory(subCategoryId);
    return mealByCategory.fold((err) {
      return Left(err);
    }, (data) {
      List<ExercisesModel> models =
          (data as List).map((e) => ExercisesModel.fromMap(e)).toList();
      List<ExercisesEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getExerciseById(int exerciseId) async {
    var mealById = await sl<ExerciseService>().getExerciseById(exerciseId);
    return mealById.fold((err) {
      return Left(err);
    }, (data) {
      return Right(ExercisesModel.fromJson(data).toEntity());
    });
  }


  @override
  Future<Either> getAllExercise() async {
    var exercises = await sl<ExerciseService>().getAllExercise();
    return exercises.fold((err) {
      return Left(err);
    }, (data) {
      List<ExercisesModel> models =
      (data as List).map((e) => ExercisesModel.fromMap(e)).toList();
      List<ExercisesEntity> entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getAllCategory() async {
    var exerciseCategory = await sl<ExerciseService>().getAllCategory();
    return exerciseCategory.fold((err) {
      return Left(err);
    }, (data) {
      List<ExerciseCategoryModel> models =
      (data as List).map((e) => ExerciseCategoryModel.fromMap(e)).toList();
      List<ExerciseCategoryEntity> entities =
      models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }


  // Result

  @override
  Future<Either> getAllExerciseProgressByUserId() async {
    var exerciseProgress =
        await sl<ExerciseService>().getAllExerciseProgressByUserId();
    return exerciseProgress.fold((err) {
      return Left(err);
    }, (data) async {
      List<ExerciseProgressModel> models =
          (data as List).map((e) => ExerciseProgressModel.fromMap(e)).toList();
      List<ExerciseProgressEntity> entities =
          models.map((m) => m.toEntity()).toList();
      final Map<int, List<ExerciseProgressEntity>> sessionsBySubCategory = {};

      for (var session in entities) {
        final subCategoryId = session.exercise!.exercise!.subCategory!.id;

        sessionsBySubCategory.putIfAbsent(subCategoryId, () => []);
        sessionsBySubCategory[subCategoryId]!.add(session);
      }
      final prefs = await SharedPreferences.getInstance();

      for (var entry in sessionsBySubCategory.entries) {
        final subCategoryId = entry.key;
        final sessions = entry.value;
        final maxBatch = sessions
            .map((s) => s.exercise?.resetBatch ?? 0)
            .fold<int>(0, (prev, current) => current > prev ? current : prev);

        await prefs.setInt("reset_batch_subCategory_$subCategoryId", maxBatch);
      }
      return Right(entities);
    });
  }

  @override
  Future<Either> getAllExerciseResultByUserId() async {
    var exerciseResult =
        await sl<ExerciseService>().getAllExerciseResultByUserId();
    return exerciseResult.fold((err) {
      return Left(err);
    }, (data) {
      List<ExerciseUserModel> models =
          (data as List).map((e) => ExerciseUserModel.fromMap(e)).toList();
      List<ExerciseUserEntity> entities =
          models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> getAllExerciseSessionByUserId() async {
    var exerciseSession =
        await sl<ExerciseService>().getAllExerciseSessionByUserId();
    return exerciseSession.fold((err) {
      return Left(err);
    }, (data) async {
      List<ExerciseSessionModel> models =
          (data as List).map((e) => ExerciseSessionModel.fromMap(e)).toList();
      List<ExerciseSessionEntity> entities =
          models.map((m) => m.toEntity()).toList();

      return Right(entities);
    });
  }

  @override
  Future<Either> startExercise(ExerciseSessionRequest req) async {
    return await sl<ExerciseService>().startExercise(req);
  }

  // Schedule

  @override
  Future<Either> getAllExerciseScheduleByUserId() async {
    var exerciseSchedule =
        await sl<ExerciseService>().getAllExerciseScheduleByUserId();
    return exerciseSchedule.fold((err) {
      return Left(err);
    }, (data) {
      List<ExerciseScheduleModel> models =
          (data as List).map((e) => ExerciseScheduleModel.fromMap(e)).toList();
      List<ExerciseScheduleEntity> entities =
          models.map((m) => m.toEntity()).toList();
      return Right(entities);
    });
  }

  @override
  Future<Either> scheduleExercise(ExerciseScheduleRequest req) async {
    return await sl<ExerciseService>().scheduleExercise(req);
  }

  @override
  Future<void> deleteExerciseSchdedule(int scheduleId) async {
    return await sl<ExerciseService>().deleteExerciseSchdedule(scheduleId);
  }

  @override
  Future<void> deleteAllExerciseScheduleByTime() async {
    return await sl<ExerciseService>().deleteAllExerciseScheduleByTime();
  }

  // Favorite

@override
  Future<Either> getAllFavorite() async {
    var favorites = await sl<ExerciseService>().getAllFavorite();
    return favorites.fold((err){
      return Left(err);
    }, (data){
      List<FavoritesModel> models = (data as List).map((e) => FavoritesModel.fromMap(e)).toList();
      List<FavoritesEntity> entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    });
  }

  @override
  Future<Either> addNewFavoriteByUserId(String favoriteName) async{
    return await sl<ExerciseService>().addNewFavoriteByUserId(favoriteName);
  }

  @override
  Future<Either> addExerciseFavoriteByUserId(ExerciseFavoriteRequest req) async {
    return await sl<ExerciseService>().addExerciseFavoriteByUserId(req);
  }

  @override
  Future<void> removeFavorite(int favoriteId) async {
    return await sl<ExerciseService>().removeFavorite(favoriteId);
  }

  @override
  Future<void> removeExerciseFavorite(int subCategoryId) async {
    return await sl<ExerciseService>().removeExerciseFavorite(subCategoryId);
  }

  @override
  Future<Either> getAllExerciseFavorite(int favoriteId) async {
    var favorites = await sl<ExerciseService>().getAllExerciseFavorite(favoriteId);
    return favorites.fold((err){
      return Left(err);
    }, (data){
      List<ExerciseFavoriteModel> models = (data as List).map((e) => ExerciseFavoriteModel.fromMap(e)).toList();
      List<ExerciseFavoriteEntity> entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    });
  }
}
