import 'dart:convert';

import 'package:projectflutter/data/meal/model/meal_sub_category.dart';
import 'package:projectflutter/data/meal/model/meal_time.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';

class MealsModel {
  final int id;
  final String mealName;
  final String mealImage;
  final double weight;
  final double kcal;
  final double fat;
  final double protein;
  final double carbonhydrate;
  final double fiber;
  final double sugar;
  final List<MealSubCategoryModel> subCategory;
  final List<MealTimeModel> timeOfDay;

  MealsModel(
      {required this.id,
      required this.mealName,
      required this.mealImage,
      required this.weight,
      required this.kcal,
      required this.fat,
      required this.protein,
      required this.carbonhydrate,
      required this.fiber,
      required this.sugar,
      required this.subCategory,
      required this.timeOfDay});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mealName': mealName,
      'mealImage': mealImage,
      'weight': weight,
      'kcal': kcal,
      'protein': protein,
      'fat': fat,
      'carbonhydrate': carbonhydrate,
      'fiber': fiber,
      'sugar': sugar,
      'subCategory': subCategory.map((e) => e.toMap()).toList(),
      'timeOfDay': timeOfDay.map((e) => e.toMap()).toList(),
    };
  }

  factory MealsModel.fromMap(Map<String, dynamic> map) {
    return MealsModel(
      id: map['id'] as int,
      mealName: map['mealName'] as String,
      mealImage: map['mealImage'] ?? '',
      weight: map['weight'] as double,
      kcal: map['kcal'] as double,
      protein: map['protein'] as double,
      fat: map['fat'] as double,
      carbonhydrate: map['carbonhydrate'] as double,
      fiber: map['fiber'] as double,
      sugar: map['sugar'] as double,
      subCategory: (map['subCategory'] as List<dynamic>?)
              ?.map((e) =>
                  MealSubCategoryModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      timeOfDay: (map['timeOfDay'] as List<dynamic>?)
              ?.map((e) => MealTimeModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory MealsModel.fromJson(String source) =>
      MealsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension MealsXModel on MealsModel {
  MealsEntity toEntity() {
    return MealsEntity(
        id: id,
        mealName: mealName,
        mealImage: mealImage,
        weight: weight,
        kcal: kcal,
        protein: protein,
        fat: fat,
        carbonhydrate: carbonhydrate,
        fiber: fiber,
        sugar: sugar,
        subCategory: subCategory,
        timeOfDay: timeOfDay);
  }
}
