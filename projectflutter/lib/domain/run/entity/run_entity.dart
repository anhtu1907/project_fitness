import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/run/model/met_model.dart';

class RunEntity {
  final int id;
  final double distance;
  final double speed;
  final double time;
  final UserModel? user;
  final MetModel? met;
  final double kcal;
  final DateTime createdAt;

  RunEntity(
      {required this.id,
      required this.distance,
      required this.speed,
      required this.time,
      required this.user,
      required this.met,
      required this.kcal,
      required this.createdAt});
}
