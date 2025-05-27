import 'package:projectflutter/data/auth/model/user.dart';

class BmiGoalEntity {
  final int id;
  final UserModel? user;
  final double targetWeight;
  final DateTime? createdAt;

  BmiGoalEntity(
      {required this.id,
      required this.user,
      required this.targetWeight,
      required this.createdAt});
}
