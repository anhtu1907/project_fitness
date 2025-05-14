import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';

class ExerciseProgressEntity {
  final int id;
  final UserModel? user;
  final ExerciseSessionModel? exercise;
  final double progress;
  final DateTime? lastUpdated;

  ExerciseProgressEntity(
      {required this.id,
      required this.user,
      required this.exercise,
      required this.progress,
      required this.lastUpdated});
}
