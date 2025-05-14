// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/exercise/entity/exercise_category_entity.dart';

class ExerciseCategoryModel {
  final int id;
  final String categoryName;
  final String categoryImage;

  ExerciseCategoryModel(
      {required this.id,
      required this.categoryName,
      required this.categoryImage});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
    };
  }

  factory ExerciseCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExerciseCategoryModel(
      id: map['id'] as int,
      categoryName: map['categoryName'] as String,
      categoryImage: map['categoryImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseCategoryModel.fromJson(String source) =>
      ExerciseCategoryModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseCategoryXModel on ExerciseCategoryModel {
  ExerciseCategoryEntity toEntity() {
    return ExerciseCategoryEntity(
        id: id, categoryImage: categoryImage, categoryName: categoryName);
  }
}
