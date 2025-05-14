// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/meal/entity/meal_time.dart';

class MealTimeModel {
  final int id;
  final String timeName;

  MealTimeModel({required this.id, required this.timeName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timeName': timeName,
    };
  }

  factory MealTimeModel.fromMap(Map<String, dynamic> map) {
    return MealTimeModel(
      id: map['id'] as int,
      timeName: map['timeName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealTimeModel.fromJson(String source) =>
      MealTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension MealTimeXModel on MealTimeModel {
  MealTimeEntity toEntity() {
    return MealTimeEntity(id: id, timeName: timeName);
  }
}
