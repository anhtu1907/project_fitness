// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

class ExercisesModel {
  final int id;
  final String exerciseName;
  final String exerciseImage;
  final String description;
  final int duration;
  final double kcal;
  final ExerciseSubCategoryModel? subCategory;

  ExercisesModel(
      {required this.id,
      required this.exerciseName,
      required this.exerciseImage,
      required this.description,
      required this.duration,
      required this.kcal,
      required this.subCategory});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'exerciseName': exerciseName,
      'exerciseImage': exerciseImage,
      'description': description,
      'duration': duration,
      'kcal': kcal,
      'subCategory': subCategory,
    };
  }

  factory ExercisesModel.fromMap(Map<String, dynamic> map) {
    return ExercisesModel(
      id: map['id'] as int,
      exerciseName: map['exerciseName'] as String,
      exerciseImage: map['exerciseImage'] ?? '',
      description: map['description'] as String,
      duration: map['duration'] as int,
      kcal: map['kcal'] as double,
      subCategory: map['subCategory'] != null
          ? ExerciseSubCategoryModel.fromMap(
              map['subCategory'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExercisesModel.fromJson(String source) =>
      ExercisesModel.fromMap(json.decode(source) as Map<String, dynamic>);
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
        subCategory: subCategory!);
  }
}
