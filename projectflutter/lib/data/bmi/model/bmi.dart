// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';

class BmiModel {
  final int id;
  final UserModel? user;
  final double height;
  final double weight;
  final double bmi;
  final DateTime? createdAt;

  BmiModel({
    required this.id,
    required this.user,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory BmiModel.fromMap(Map<String, dynamic> map) {
    return BmiModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      height: map['height'] as double,
      weight: map['weight'] as double,
      bmi: map['bmi'] as double,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BmiModel.fromJson(String source) =>
      BmiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension BmiXModel on BmiModel {
  BmiEntity toEntity() {
    return BmiEntity(
        id: id,
        user: user,
        height: height,
        weight: weight,
        bmi: bmi,
        createdAt: createdAt);
  }
}
