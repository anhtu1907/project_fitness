// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';

class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String image;
  final DateTime? dob;
  final int gender;
  final String phone;
  final String token;
  final String pinCode;
  final bool status;
  final int roleid;
  final BmiModel? bmiid;
  final DateTime? createdAt;

  UserModel(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.password,
      required this.image,
      required this.dob,
      required this.gender,
      required this.phone,
      required this.token,
      required this.pinCode,
      required this.status,
      required this.roleid,
      required this.bmiid,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'image': image,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'token': token,
      'pinCode': pinCode,
      'status': status,
      'roleid': roleid,
      'bmiid': bmiid,
      'createdAt': createdAt
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as int,
        firstname: map['firstname'] as String,
        lastname: map['lastname'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        image: map['image'] ?? '',
        dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
        gender: map['gender'] as int,
        phone: map['phone'] as String,
        token: map['token'] ?? '',
        pinCode: map['pinCode'] ?? '',
        status: map['status'] as bool,
        roleid: map['roleid'] as int,
        bmiid: map['bmiid'] != null
            ? BmiModel.fromMap(map['bmiid'] as Map<String, dynamic>)
            : null,
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
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        image: image,
        dob: dob!,
        gender: gender,
        phone: phone,
        token: token,
        pinCode: pinCode,
        status: status,
        roleid: roleid,
        bmiid: bmiid,
        createdAt: createdAt!);
  }
}
