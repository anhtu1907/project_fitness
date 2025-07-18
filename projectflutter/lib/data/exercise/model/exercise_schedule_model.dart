// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:projectflutter/data/auth/model/user_simple_dto.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_schedule_entity.dart';

class ExerciseScheduleModel {
  final int id;
  final UserSimpleDTO? user;
  final ExerciseSubCategoryModel? subCategory;
  final DateTime? scheduleTime;

  ExerciseScheduleModel(
      {required this.id,
      required this.user,
      required this.subCategory,
      required this.scheduleTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'subCategory': subCategory,
      'scheduleTime': scheduleTime?.toIso8601String(),
    };
  }

  factory ExerciseScheduleModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedScheduleTime;
    if (map['scheduleTime'] is List && (map['scheduleTime'] as List).length >= 5) {
      final list = map['scheduleTime'] as List;
      parsedScheduleTime = DateTime(
        list[0],
        list[1],
        list[2],
        list[3],
        list[4],
      );
    }
    return ExerciseScheduleModel(
      id: map['id'] as int,
      user: map['user'] != null
          ? UserSimpleDTO.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      subCategory: map['subCategory'] != null
          ? ExerciseSubCategoryModel.fromMap(
              map['subCategory'] as Map<String, dynamic>)
          : null,
      scheduleTime: parsedScheduleTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseScheduleModel.fromJson(String source) =>
      ExerciseScheduleModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseScheduleXModel on ExerciseScheduleModel {
  ExerciseScheduleEntity toEntity() {
    return ExerciseScheduleEntity(
        id: id,
        user: user,
        subCategory: subCategory,
        scheduleTime: scheduleTime);
  }
}
