import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:projectflutter/data/bmi/model/bmi_goal.dart';

class UserEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final DateTime? dob;
  final int gender;
  final String phone;
  final String address;

  UserEntity(
      {required this.id,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
        required this.dob,
        required this.gender,
        required this.phone,
        required this.address});
}
