package aptech.finalproject.service.meal;

import java.time.LocalDate;
import java.util.List;

import aptech.finalproject.payload.meal.UserMealsRequest;
import aptech.finalproject.dto.meal.MealCategoryDTO;
import aptech.finalproject.dto.meal.MealSubCategoryDTO;
import aptech.finalproject.dto.meal.MealsDTO;
import aptech.finalproject.dto.meal.UserMealDTO;
import aptech.finalproject.entity.meal.MealsModel;


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
