// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:projectflutter/data/bmi/model/bmi_goal.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';

class UserModel {
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

  UserModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'token': token,
      'pinCode': pinCode,
      'active': active,
      'createdAt': createdAt!.toIso8601String()
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as int,
        username: map['username'] as String,
        firstname: map['firstname'] as String,
        lastname: map['lastname'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
        gender: map['gender'] as int,
        phone: map['phone'] as String,
        token: map['token'] ?? '',
        pinCode: map['pinCode'] ?? '',
        active: map['active'] as bool,
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        id: id,
        username: username,
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        dob: dob!,
        gender: gender,
        phone: phone,
        token: token,
        pinCode: pinCode,
        active: active,
        createdAt: createdAt!);
  }
}
