// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercises_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_session_entity.dart';

class ExerciseSessionModel {
  final int id;
  final UserModel? user;
  final ExercisesModel? exercise;
  final double kcal;
  final int resetBatch;
  final int duration;
  final DateTime? createdAt;

  ExerciseSessionModel(
      {required this.id,
      required this.user,
      required this.exercise,
      required this.kcal,
      required this.resetBatch,
      required this.duration,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'exercise': exercise,
      'kcal': kcal,
      'resetBatch': resetBatch,
      'duration': duration,
      'createdAt': createdAt?.toIso8601String()
    };
  }

  factory ExerciseSessionModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSessionModel(
        id: map['id'] as int,
        user: map['user'] != null
            ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
            : null,
        exercise: map['exercise'] != null
            ? ExercisesModel.fromMap(map['exercise'] as Map<String, dynamic>)
            : null,
        kcal: map['kcal'] as double,
        resetBatch: map['resetBatch'] as int,
        duration: map['duration'] as int,
        createdAt:
            map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null);
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSessionModel.fromJson(String source) =>
      ExerciseSessionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ExerciseSessionXModel on ExerciseSessionModel {
  ExerciseSessionEntity toEntity() {
    return ExerciseSessionEntity(
        id: id,
        user: user,
        exercise: exercise,
        duration: duration,
        kcal: kcal,
        resetBatch: resetBatch,
        createdAt: createdAt);
  }
}
