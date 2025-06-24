import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/meal/request/user_meal_request.dart';

abstract class MealRepository {
  Future<Either> getAllMeal();
  Future<Either> getAllCategory();
  Future<Either> getAllSubCategory();
  Future<Either> getAllRecordMeal();
  Future<Either> getMealBySubCategory(int subCategoryId);
  Future<Either> getMealById(int mealId);
  Future<Either> saveRecordMeal(UserMealRequest req);
  Future<void> deteleRecordMeal(int recordId);
  Future<void> deteleAllRecordMeal(DateTime targetDate);
  Future<Either> searchByMealName(String mealName);
}
