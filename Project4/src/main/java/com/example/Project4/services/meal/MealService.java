package com.example.Project4.services.meal;

import java.util.List;

import com.example.Project4.dto.meal.UserMealsRequest;
import com.example.Project4.models.meal.MealCategoryModel;
import com.example.Project4.models.meal.MealSubCategoryModel;
import com.example.Project4.models.meal.MealsModel;
import com.example.Project4.models.meal.UserMealsModel;

public interface MealService {
    List<MealsModel> getAllMeal();
    List<MealCategoryModel> getAllCategory();
    List<MealSubCategoryModel> getAllSubCategory();
    List<MealsModel> searchByMealName(String mealName);
    MealsModel getMealById(int mealId);
    List<MealsModel> getMealBySubCategoryId(int subCategoryId);
    List<UserMealsModel> saveRecordMeal(UserMealsRequest request);
    List<UserMealsModel> getRecordMeal(int userId);
    void deleteRecordMeal(int recordId);
    void deleteAllRecordMeal(int userId);
}
