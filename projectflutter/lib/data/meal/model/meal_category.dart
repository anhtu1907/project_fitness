// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/domain/meal/entity/meal_category.dart';

class MealCategoryModel {
  final int id;
  final String categoryImage;
  final String categoryName;

  MealCategoryModel(
      {required this.id,
      required this.categoryImage,
      required this.categoryName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryImage': categoryImage,
      'categoryName': categoryName,
    };
  }

  factory MealCategoryModel.fromMap(Map<String, dynamic> map) {
    return MealCategoryModel(
      id: map['id'] as int,
      categoryImage: map['categoryImage'] ?? '',
      categoryName: map['categoryName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealCategoryModel.fromJson(String source) =>
      MealCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension MealCategoryXModel on MealCategoryModel {
  MealCategoryEntity toEntity() {
    return MealCategoryEntity(
        id: id, categoryImage: categoryImage, categoryName: categoryName);
  }
}
