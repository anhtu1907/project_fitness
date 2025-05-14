// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/run/entity/met_entity.dart';

class MetModel {
  final int id;
  final String name;
  final double minSpeed;
  final double maxSpeed;
  final int met;

  MetModel(
      {required this.id,
      required this.name,
      required this.minSpeed,
      required this.maxSpeed,
      required this.met});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'minSpeed': minSpeed,
      'maxSpeed': maxSpeed,
      'met': met,
    };
  }

  factory MetModel.fromMap(Map<String, dynamic> map) {
    return MetModel(
      id: map['id'] as int,
      name: map['name'] as String,
      minSpeed: map['minSpeed'] as double,
      maxSpeed: map['maxSpeed'] as double,
      met: map['met'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MetModel.fromJson(String source) =>
      MetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension MetXModel on MetModel {
  MetEntity toEntity() {
    return MetEntity(
        id: id, name: name, minSpeed: minSpeed, maxSpeed: maxSpeed, met: met);
  }
}
