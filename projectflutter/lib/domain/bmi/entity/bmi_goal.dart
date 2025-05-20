import 'package:projectflutter/data/auth/model/user.dart';

class BmiGoalEntity {
  final int id;
  final UserModel? user;
  final int targetWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BmiGoalEntity(
      {required this.id,
      required this.user,
      required this.targetWeight,
      required this.createdAt,
      required this.updatedAt});
}
