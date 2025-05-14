// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/bmi/entity/bmi.dart';

class BmiModel {
  final int id;
  final int height;
  final int weight;
  final double bmi;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'height': height,
      'weight': weight,
      'bmi': bmi,
    };
  }

  factory BmiModel.fromMap(Map<String, dynamic> map) {
    return BmiModel(
      id: map['id'] as int,
      height: map['height'] as int,
      weight: map['weight'] as int,
      bmi: map['bmi'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BmiModel.fromJson(String source) =>
      BmiModel.fromMap(json.decode(source) as Map<String, dynamic>);

  BmiModel(
      {required this.id,
      required this.height,
      required this.weight,
      required this.bmi});
}

extension BmiXModel on BmiModel {
  BmiEntity toEntity() {
    return BmiEntity(id: id, height: height, weight: weight, bmi: bmi);
  }
}
