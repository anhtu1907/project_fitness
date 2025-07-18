// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';

class ExerciseProgressModel {
  final int id;
  final UserSimpleDTO? user;
  final ExerciseSessionModel? session;
  final double progress;
  final DateTime? lastUpdated;

  ExerciseProgressModel(
      {required this.id,
      required this.user,
      required this.session,
      required this.progress,
      required this.lastUpdated});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'exercises': session,
      'progress': progress,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory ExerciseProgressModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedLastUpdated;
    if (map['lastUpdated'] is List && (map['lastUpdated'] as List).length >= 6) {
      final list = map['lastUpdated'] as List;
      parsedLastUpdated = DateTime(
        list[0],
        list[1],
        list[2],
        list[3],
        list[4],
        list[5],
      );
    }
    return ExerciseProgressModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserSimpleDTO.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      session: map['session'] != null
          ? ExerciseSessionModel.fromMap(
              map['session'] as Map<String, dynamic>)
          : null,
      progress: map['progress'] as double,
      lastUpdated: parsedLastUpdated,
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
        session: session,
        progress: progress,
        lastUpdated: lastUpdated);
  }
}
