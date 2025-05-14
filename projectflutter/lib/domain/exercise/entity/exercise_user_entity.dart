import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';

class ExerciseUserEntity {
  final int id;
  final UserModel? user;
  final ExerciseSessionModel? session;
  final double kcal;
  final DateTime? createdAt;

  ExerciseUserEntity(
      {required this.id,
      required this.user,
      required this.session,
      required this.kcal,
      required this.createdAt});
}
