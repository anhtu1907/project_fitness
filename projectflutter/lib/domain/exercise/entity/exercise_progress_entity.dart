import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';

class ExerciseProgressEntity {
  final int id;
  final UserSimpleDTO? user;
  final ExerciseSessionModel? session;
  final double progress;
  final DateTime? lastUpdated;

  ExerciseProgressEntity(
      {required this.id,
      required this.user,
      required this.session,
      required this.progress,
      required this.lastUpdated});
}
