// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';

class BmiGoalModel {
  final int id;
  final UserModel? user;
  final int targetWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BmiGoalModel(
      {required this.id,
      required this.user,
      required this.targetWeight,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'targetWeight': targetWeight,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BmiGoalModel.fromMap(Map<String, dynamic> map) {
    return BmiGoalModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      targetWeight: map['targetWeight'] as int,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BmiGoalModel.fromJson(String source) =>
      BmiGoalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension BmiGoalXModel on BmiGoalModel {
  BmiGoalEntity toEntity() {
    return BmiGoalEntity(
        id: id,
        user: user,
        targetWeight: targetWeight,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}
