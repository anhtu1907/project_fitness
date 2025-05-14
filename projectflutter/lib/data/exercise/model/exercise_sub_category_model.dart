// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/exercise/model/exercise_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';

class ExerciseSubCategoryModel {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final ExerciseCategoryModel? category;
  final ExerciseModeModel? mode;

  ExerciseSubCategoryModel(
      {required this.id,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.description,
      required this.category,
      required this.mode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subCategoryName': subCategoryName,
      'subCategoryImage': subCategoryImage,
      'description': description,
      'category': category,
      'mode': mode,
    };
  }

  factory ExerciseSubCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSubCategoryModel(
      id: map['id'] as int,
      subCategoryName: map['subCategoryName'] ?? '',
      subCategoryImage: map['subCategoryImage'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] != null
          ? ExerciseCategoryModel.fromMap(
              map['category'] as Map<String, dynamic>)
          : null,
      mode: map['mode'] != null
          ? ExerciseModeModel.fromMap(map['mode'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSubCategoryModel.fromJson(String source) =>
      ExerciseSubCategoryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseSubCategorysXModel on ExerciseSubCategoryModel {
  ExerciseSubCategoryEntity toEntity() {
    return ExerciseSubCategoryEntity(
        id: id,
        subCategoryName: subCategoryName,
        subCategoryImage: subCategoryImage,
        description: description,
        category: category,
        mode: mode);
  }
}
