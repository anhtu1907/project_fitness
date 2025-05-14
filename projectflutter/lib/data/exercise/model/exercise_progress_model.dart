// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';

class ExerciseProgressModel {
  final int id;
  final UserModel? user;
  final ExerciseSessionModel? exercise;
  final double progress;
  final DateTime? lastUpdated;

  ExerciseProgressModel(
      {required this.id,
      required this.user,
      required this.exercise,
      required this.progress,
      required this.lastUpdated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'exercises': exercise,
      'progress': progress,
      'lastUpdated': lastUpdated,
    };
  }

  factory ExerciseProgressModel.fromMap(Map<String, dynamic> map) {
    return ExerciseProgressModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      exercise: map['exercise'] != null
          ? ExerciseSessionModel.fromMap(
              map['exercise'] as Map<String, dynamic>)
          : null,
      progress: map['progress'] as double,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseProgressModel.fromJson(String source) =>
      ExerciseProgressModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseProgressXModel on ExerciseProgressModel {
  ExerciseProgressEntity toEntity() {
    return ExerciseProgressEntity(
        id: id,
        user: user,
        exercise: exercise,
        progress: progress,
        lastUpdated: lastUpdated);
  }
}
