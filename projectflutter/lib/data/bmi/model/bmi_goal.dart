// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';

class BmiGoalModel {
  final int id;
  final UserModel? user;
  final double targetWeight;
  final DateTime? createdAt;

  BmiGoalModel(
      {required this.id,
      required this.user,
      required this.targetWeight,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'targetWeight': targetWeight,
      'createdAt': createdAt?.toIso8601String()
    };
  }

  factory BmiGoalModel.fromMap(Map<String, dynamic> map) {
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
    return BmiGoalModel(
        id: map['id'] as int,
        user: map['user'] != null
            ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        targetWeight: map['targetWeight'] as double,
        createdAt: parsedCreatedAt);
  }

  String toJson() => json.encode(toMap());

  factory BmiGoalModel.fromJson(String source) =>
      BmiGoalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension BmiGoalXModel on BmiGoalModel {
  BmiGoalEntity toEntity() {
    return BmiGoalEntity(
        id: id, user: user, targetWeight: targetWeight, createdAt: createdAt);
  }
}
