import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/meal/model/meals.dart';

class UserMealsEntity {
  final int id;
  final UserModel user;
  final MealsModel meal;
  final DateTime? createdAt;

  UserMealsEntity(
      {required this.id,
      required this.user,
      required this.meal,
      required this.createdAt});
}
