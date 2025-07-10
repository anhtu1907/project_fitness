// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:projectflutter/data/meal/model/meal_category.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';

class MealSubCategoryModel {
  final int id;
  final String subCategoryName;
  final String subCategoryImage;
  final String description;
  final MealCategoryModel? category;

  MealSubCategoryModel(
      {required this.id,
      required this.subCategoryName,
      required this.subCategoryImage,
      required this.description,
      required this.category});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subCategoryName': subCategoryName,
      'subCategoryImage': subCategoryImage,
      'description': description,
      'category': category,
    };
  }

  factory MealSubCategoryModel.fromMap(Map<String, dynamic> map) {
    return MealSubCategoryModel(
      id: map['id'] as int,
      subCategoryName: map['subCategoryName'] as String,
      subCategoryImage: map['subCategoryImage'] ?? '',
      description: map['description'] as String,
      category: map['category'] != null
          ? MealCategoryModel.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealSubCategoryModel.fromJson(String source) =>
      MealSubCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension MealSubCategoryXModel on MealSubCategoryModel {
  MealSubCategoryEntity toEntity() {
    return MealSubCategoryEntity(
        id: id,
        subCategoryName: subCategoryName,
        subCategoryImage: subCategoryImage,
        description: description,
        category: category);
  }
}
