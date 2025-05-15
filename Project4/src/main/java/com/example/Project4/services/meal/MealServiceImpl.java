package com.example.Project4.services.meal;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.dto.meal.UserMealsRequest;
import com.example.Project4.models.meal.MealCategoryModel;
import com.example.Project4.models.meal.MealSubCategoryModel;
import com.example.Project4.models.meal.MealsModel;
import com.example.Project4.models.meal.UserMealsModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.meal.MealCategoryRepository;
import com.example.Project4.repository.meal.MealsRepository;
import com.example.Project4.repository.meal.MealSubCategoryRepository;
import com.example.Project4.repository.meal.UserMealsRepository;

import jakarta.transaction.Transactional;

@Service
public class MealServiceImpl implements MealService {
    @Autowired
    private MealsRepository mealRepository;
    @Autowired
    private MealCategoryRepository mCategoryRepository;

    @Autowired
    private MealSubCategoryRepository mSubCategoryRepository;
    @Autowired
    private UserMealsRepository uMealsRepository;
    @Autowired
    private UserRepository uRepository;

    @Override
    public List<MealCategoryModel> getAllCategory() {
        return mCategoryRepository.findAll();
    }

    @Override
    public List<MealsModel> getAllMeal() {
        return mealRepository.findAll();
    }

    @Override
    public List<MealSubCategoryModel> getAllSubCategory() {
        return mSubCategoryRepository.findAll();
    }

    @Override
    public MealsModel getMealById(int mealId) {
        MealsModel meal = mealRepository.findById(mealId).orElseThrow(() -> new RuntimeException("Meal not found by mealID:" + mealId));
        return meal;
    }

    @Override
    public List<MealsModel> getMealBySubCategoryId(int subCategoryId) {
        return mealRepository.findAllBySubCategoryId(subCategoryId);
    }

    @Override
    public List<UserMealsModel> getRecordMeal(int userId) {
        List<UserMealsModel> record = uMealsRepository.findByUserId(userId);
        if(record.isEmpty()){
            throw new RuntimeException("No meals found for this user");
        }
        return record;
    }
    

    @Override
    public List<UserMealsModel> saveRecordMeal(UserMealsRequest request) {
        var user = uRepository.findById(request.getUser())
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<UserMealsModel> saveRecords = new ArrayList<>();
        for (Integer mealId : request.getMeal()) {
            var meal = mealRepository.findById(mealId)
                    .orElseThrow(() -> new RuntimeException("Meal not found with id: " + mealId));
            UserMealsModel usermeals = new UserMealsModel();
            usermeals.setUser(user);
            usermeals.setMeal(meal);
            usermeals.setCreatedAt(LocalDateTime.now());
            saveRecords.add(uMealsRepository.save(usermeals));
        }

        return saveRecords;
    }

    @Override
    public void deleteRecordMeal(int recordId) {
        uMealsRepository.deleteById(recordId);
    }

    @Override
    @Transactional
    public void deleteAllRecordMeal(int userId) {
        uMealsRepository.deleteAllByUserId(userId);
    }

    @Override
    public List<MealsModel> searchByMealName(String mealName) {
        List<MealsModel> meals = mealRepository.findByMealNameLike("%" + mealName + "%");
        if(meals.isEmpty()){
            throw new RuntimeException("No meals found for meal name");
        }
        return meals;
    }
}
