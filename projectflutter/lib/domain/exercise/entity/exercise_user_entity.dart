import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';

class ExerciseUserEntity {
  final int id;
  final UserSimpleDTO? user;
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
