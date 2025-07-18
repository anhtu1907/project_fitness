package com.example.Project4.service.meal;

import java.time.LocalDate;
import java.util.List;

import com.example.Project4.payload.meal.UserMealsRequest;
import com.example.Project4.dto.meal.MealCategoryDTO;
import com.example.Project4.dto.meal.MealSubCategoryDTO;
import com.example.Project4.dto.meal.MealsDTO;
import com.example.Project4.dto.meal.UserMealDTO;
import com.example.Project4.entity.meal.MealsModel;


public interface MealService {
    List<MealsDTO> getAllMeal();
    List<MealCategoryDTO> getAllCategory();
    List<MealSubCategoryDTO> getAllSubCategory();
    List<MealsModel> searchByMealName(String mealName);
    MealsDTO getMealById(int mealId);
    List<MealsDTO> getMealBySubCategoryId(int subCategoryId);
    List<UserMealDTO> saveRecordMeal(UserMealsRequest request);
    List<UserMealDTO> getRecordMeal(String userId);
    void deleteRecordMeal(int recordId);
    void deleteAllRecordMeal(String userId, LocalDate date);
}
