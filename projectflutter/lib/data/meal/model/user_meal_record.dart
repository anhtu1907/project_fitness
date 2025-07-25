// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/meal/model/meals.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';

class UserMealRecord {
  final int id;
  final UserSimpleDTO? user;
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
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserMealRecord.fromMap(Map<String, dynamic> map) {
    DateTime? parsedCreatedAt;
    if (map['createdAt'] is List && (map['createdAt'] as List).length >= 6) {
      final list = map['createdAt'] as List;
      parsedCreatedAt = DateTime(
        list[0], // year
        list[1], // month
        list[2], // day
        list[3], // hour
        list[4], // minute
        list[5], // second
      );
    }
    return UserMealRecord(
        id: map['id'] as int,
        user: map['user'] != null
            ? UserSimpleDTO.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        meal: map['meal'] != null
            ? MealsModel.fromMap(map['meal'] as Map<String, dynamic>)
            : null,
        createdAt: parsedCreatedAt);
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
