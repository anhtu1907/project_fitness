import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:projectflutter/data/bmi/model/bmi_goal.dart';

class UserEntity {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final DateTime? dob;
  final int gender;
  final String phone;
  final String token;
  final String pinCode;
  final bool active;
  final DateTime? createdAt;

  UserEntity(
      {required this.id,
      required this.username,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.dob,
      required this.gender,
      required this.phone,
      required this.token,
      required this.pinCode,
      required this.active,
      required this.createdAt});
}
