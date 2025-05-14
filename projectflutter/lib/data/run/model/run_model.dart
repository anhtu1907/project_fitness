// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/run/model/met_model.dart';
import 'package:projectflutter/domain/run/entity/run_entity.dart';

class RunModel {
  final int id;
  final double distance;
  final double speed;
  final double time;
  final UserModel? user;
  final MetModel? met;
  final double kcal;
  final DateTime? createdAt;

  RunModel(
      {required this.id,
      required this.distance,
      required this.speed,
      required this.time,
      required this.user,
      required this.met,
      required this.kcal,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'distance': distance,
      'speed': speed,
      'time': time,
      'user': user,
      'met': met,
      'kcal': kcal,
      'createdAt': createdAt,
    };
  }

  factory RunModel.fromMap(Map<String, dynamic> map) {
    return RunModel(
        id: map['id'] as int,
        distance: map['distance'] as double,
        speed: map['speed'] as double,
        time: map['time'] as double,
        user: map['user'] != null
            ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        met: map['met'] != null
            ? MetModel.fromMap(map['met'] as Map<String, dynamic>)
            : null,
        kcal: map['kcal'] as double,
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null);
  }

  String toJson() => json.encode(toMap());

  factory RunModel.fromJson(String source) =>
      RunModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension RunXModel on RunModel {
  RunEntity toEntity() {
    return RunEntity(
        id: id,
        distance: distance,
        speed: speed,
        time: time,
        user: user,
        met: met,
        kcal: kcal,
        createdAt: createdAt!);
  }
}
