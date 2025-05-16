import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/exercise/model/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_request.dart';

abstract class ExerciseRepository {
  Future<Either> getExerciseBySubCategory(int subCategoryId);
  Future<Either> getExerciseById(int exerciseId);
  Future<Either> getAllSubCategory();
  Future<Either> startExercise(ExerciseSessionRequest req);
  Future<Either> scheduleExercise(ExerciseScheduleRequest req);
  Future<Either> getAllExerciseProgressByUserId();
  Future<Either> getAllExerciseSessionByUserId();
  Future<Either> getAllExerciseResultByUserId();
  Future<Either> getAllExerciseScheduleByUserId();
  Future<Either> getAllExercise();
  Future<Either> getAllCategory();
  Future<void> deleteExerciseSchdedule(int scheduleId);
  Future<void> deleteAllExerciseScheduleByTime();
}
