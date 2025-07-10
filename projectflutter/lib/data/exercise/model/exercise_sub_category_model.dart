// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/exercise/model/exercise_category_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_favorite_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_programs_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_schedule_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';

class ExerciseSubCategoryModel {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final List<ExerciseCategoryModel> category;

  ExerciseSubCategoryModel({
    required this.id,
    required this.subCategoryName,
    required this.subCategoryImage,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subCategoryName': subCategoryName,
      'subCategoryImage': subCategoryImage,
      'description': description,
      'category': category.map((x) => x.toMap()).toList()
    };
  }

  factory ExerciseSubCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSubCategoryModel(
      id: map['id'] as int,
      subCategoryName: map['subCategoryName'] ?? '',
      subCategoryImage: map['subCategoryImage'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] != null
          ? List<ExerciseCategoryModel>.from(
              (map['category'] as List).map(
                (x) => ExerciseCategoryModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseSubCategoryModel.fromJson(String source) =>
      ExerciseSubCategoryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseSubCategoryXModel on ExerciseSubCategoryModel {
  ExerciseSubCategoryEntity toEntity() {
    return ExerciseSubCategoryEntity(
      id: id,
      subCategoryName: subCategoryName,
      subCategoryImage: subCategoryImage,
      description: description,
      category: category
    );
  }
}