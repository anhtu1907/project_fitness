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
    return BmiModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      height: map['height'] as double,
      weight: map['weight'] as double,
      bmi: map['bmi'] as double,
      createdAt: parsedCreatedAt,
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
