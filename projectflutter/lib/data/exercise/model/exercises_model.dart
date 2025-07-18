// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:projectflutter/data/exercise/model/equipments_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

import 'dart:convert';
import 'package:projectflutter/data/exercise/model/equipments_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

class ExercisesModel {
  final int id;
  final String exerciseName;
  final String exerciseImage;
  final String description;
  final int duration;
  final double kcal;
  final List<ExerciseSubCategoryModel> subCategory;
  final EquipmentsModel? equipment;
  final List<ExerciseModeModel> modes;

  ExercisesModel({
    required this.id,
    required this.exerciseName,
    required this.exerciseImage,
    required this.description,
    required this.duration,
    required this.kcal,
    required this.subCategory,
    required this.equipment,
    required this.modes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'exerciseName': exerciseName,
      'exerciseImage': exerciseImage,
      'description': description,
      'duration': duration,
      'kcal': kcal,
      'subCategory': subCategory.map((e) => e.toMap()).toList(),
      'equipment': equipment?.toMap(),
      'modes': modes.map((e) => e.toMap()).toList(),
    };
  }

  factory ExercisesModel.fromMap(Map<String, dynamic> map) {
    return ExercisesModel(
      id: map['id'] as int,
      exerciseName: map['exerciseName'] ?? '',
      exerciseImage: map['exerciseImage'] ?? '',
      description: map['description'] ?? '',
      duration: map['duration'] as int,
      kcal: map['kcal']?.toDouble() ?? 0.0,
      subCategory: (map['subCategory'] as List<dynamic>?)
          ?.map((e) => ExerciseSubCategoryModel.fromMap(e))
          .toList() ??
          [],
      equipment: map['equipment'] != null
          ? EquipmentsModel.fromMap(map['equipment'])
          : null,
      modes: (map['modes'] as List<dynamic>?)
          ?.map((e) => ExerciseModeModel.fromMap(e))
          .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExercisesModel.fromJson(String source) =>
      ExercisesModel.fromMap(json.decode(source));
}


extension ExercisesXModel on ExercisesModel {
  ExercisesEntity toEntity() {
    return ExercisesEntity(
      id: id,
      exerciseName: exerciseName,
      exerciseImage: exerciseImage,
      description: description,
      duration: duration,
      kcal: kcal,
      subCategory: subCategory,
      equipment: equipment,
      modes: modes,
    );
  }
}
