import 'dart:convert';
import 'package:projectflutter/domain/auth/entity/user.dart';

class UserModel {
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

  UserModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'address': address
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedDob;
    if (map['dob'] is List && (map['dob'] as List).length >= 3) {
      final dobList = map['dob'] as List;
      final year = dobList[0] as int;
      final month = dobList[1] as int;
      final day = dobList[2] as int;
      parsedDob = DateTime(year, month, day);
    }
    return UserModel(
        id: map['id']  ?? '',
        username: map['username'] ?? '',
        firstName: map['firstName']  ?? '',
        lastName: map['lastName']  ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        dob: parsedDob,
        gender: map['gender'] != null ? map['gender'] as int : 0,
        phone: map['phone']  ?? '',
        address: map['address']  ?? '');
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
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        dob: dob!,
        gender: gender,
        phone: phone,
        address: address);
  }
}