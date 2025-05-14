import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercises_model.dart';

class ExerciseSessionEntity {
  final int id;
  final UserModel? user;
  final ExercisesModel? exercise;
  final double kcal;
  final int resetBatch;
  final int duration;
  final DateTime? createdAt;

  ExerciseSessionEntity(
      {required this.id,
      required this.user,
      required this.exercise,
      required this.kcal,
      required this.resetBatch,
      required this.duration,
      required this.createdAt});
}
