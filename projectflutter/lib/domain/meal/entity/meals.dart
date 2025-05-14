import 'package:projectflutter/data/meal/model/meal_sub_category.dart';
import 'package:projectflutter/data/meal/model/meal_time.dart';

class MealsEntity {
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
  final MealSubCategoryModel subCategory;
  final MealTimeModel timeOfDay;

  MealsEntity(
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
}
