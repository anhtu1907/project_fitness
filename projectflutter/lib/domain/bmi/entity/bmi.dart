import 'package:projectflutter/data/auth/model/user.dart';

class BmiEntity {
  final int id;
  final UserModel? user;
  final double height;
  final double weight;
  final double bmi;
  final DateTime? createdAt;

  BmiEntity(
      {required this.id,
      required this.user,
      required this.height,
      required this.weight,
      required this.bmi,
      required this.createdAt});
}
