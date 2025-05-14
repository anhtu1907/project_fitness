import 'package:dartz/dartz.dart';

abstract class MealRepository {
  Future<Either> getAllMeal();
  Future<Either> getAllCategory();
  Future<Either> getAllSubCategory();
  Future<Either> getAllRecordMeal();
  Future<Either> getMealBySubCategory(int subCategoryId);
  Future<Either> getMealById(int mealId);
  Future<Either> saveRecordMeal(int mealId);
  Future<void> deteleRecordMeal(int mealId);
  Future<Either> searchByMealName(String mealName);
}
