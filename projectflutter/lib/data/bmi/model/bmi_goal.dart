// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';

class BmiGoalModel {
  final int id;
  final double targetWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BmiGoalModel(
      {required this.id,
      required this.targetWeight,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'targetWeight': targetWeight,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory BmiGoalModel.fromMap(Map<String, dynamic> map) {
    return BmiGoalModel(
      id: map['id'] as int,
      targetWeight: map['targetWeight'] as double,
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
        targetWeight: targetWeight,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}
