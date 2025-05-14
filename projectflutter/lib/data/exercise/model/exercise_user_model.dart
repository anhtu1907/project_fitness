// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/auth/model/user.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';

class ExerciseUserModel {
  final int id;
  final UserModel? user;
  final ExerciseSessionModel? session;
  final double kcal;
  final DateTime? createdAt;

  ExerciseUserModel(
      {required this.id,
      required this.user,
      required this.session,
      required this.kcal,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'session': session,
      'kcal': kcal,
      'createdAt': createdAt,
    };
  }

  factory ExerciseUserModel.fromMap(Map<String, dynamic> map) {
    return ExerciseUserModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      session: map['session'] != null
          ? ExerciseSessionModel.fromMap(map['session'] as Map<String, dynamic>)
          : null,
      kcal: map['kcal'] as double,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseUserModel.fromJson(String source) =>
      ExerciseUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ExerciseUserXModel on ExerciseUserModel {
  ExerciseUserEntity toEntity() {
    return ExerciseUserEntity(
        id: id, user: user, session: session, kcal: kcal, createdAt: createdAt);
  }
}
