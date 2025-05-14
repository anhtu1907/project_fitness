// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/exercise/entity/exercise_mode_entity.dart';

class ExerciseModeModel {
  final int id;
  final String modeName;

  ExerciseModeModel({required this.id, required this.modeName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'modeName': modeName,
    };
  }

  factory ExerciseModeModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModeModel(
      id: map['id'] as int,
      modeName: map['modeName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseModeModel.fromJson(String source) =>
      ExerciseModeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ExerciseModeXModel on ExerciseModeModel {
  ExerciseModeEntity toEntity() {
    return ExerciseModeEntity(id: id, modeName: modeName);
  }
}
