// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/meal/model/meals.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';

class UserMealRecord {
  final int id;
  final UserModel? user;
  final MealsModel? meal;
  final DateTime? createdAt;

  UserMealRecord(
      {required this.id,
      required this.user,
      required this.meal,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'meal': meal,
      'createdAt': createdAt,
    };
  }

  factory UserMealRecord.fromMap(Map<String, dynamic> map) {
    return UserMealRecord(
        id: map['id'] as int,
        user: map['user'] != null
            ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        meal: map['meal'] != null
            ? MealsModel.fromMap(map['meal'] as Map<String, dynamic>)
            : null,
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null);
  }

  String toJson() => json.encode(toMap());

  factory UserMealRecord.fromJson(String source) =>
      UserMealRecord.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserMealRecordXModel on UserMealRecord {
  UserMealsEntity toEntity() {
    return UserMealsEntity(
        id: id, user: user!, meal: meal!, createdAt: createdAt!);
  }
}
