package com.example.Project4.service.meal;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.meal.*;
import com.example.Project4.dto.meal.*;
import com.example.Project4.entity.meal.*;
import com.example.Project4.mapper.MealMapper;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.meal.*;

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
    public List<MealCategoryDTO> getAllCategory() {
        return mCategoryRepository.findAll().stream().map(MealMapper::toCategoryDto).collect(Collectors.toList());
    }

    @Override
    public List<MealsDTO> getAllMeal() {
        return mealRepository.findAll().stream().map(MealMapper::toMealDto).collect(Collectors.toList());
    }

    @Override
    public List<MealSubCategoryDTO> getAllSubCategory() {
        return mSubCategoryRepository.findAll().stream().map(MealMapper::toSubCategoryDto).collect(Collectors.toList());
    }

    @Override
    public MealsDTO getMealById(int mealId) {
        MealsModel meal = mealRepository.findById(mealId)
                .orElseThrow(() -> new RuntimeException("Meal not found by mealID:" + mealId));
        return MealMapper.toMealDto(meal);
    }

    @Override
    public List<MealsDTO> getMealBySubCategoryId(int subCategoryId) {
        List<MealsModel> meals = mealRepository.findAllBySubCategoryId(subCategoryId);
         return meals.stream()
            .map(MealMapper::toMealDto)
            .collect(Collectors.toList());
    }

    @Override
    public List<UserMealDTO> getRecordMeal(String userId) {
        List<UserMealsModel> records = uMealsRepository.findByUserId(userId);
        List<UserMealDTO> dtos = records.stream()
                                    .map(MealMapper::toUserMealDTO)
                                    .collect(Collectors.toList());
        return dtos;
    }

    @Override
    public List<UserMealDTO> saveRecordMeal(UserMealsRequest request) {
        var user = uRepository.findById(request.getUser())
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<UserMealsModel> saveRecords = new ArrayList<>();
        for (Integer mealId : request.getMeal()) {
            var meal = mealRepository.findById(mealId)
                    .orElseThrow(() -> new RuntimeException("Meal not found with id: " + mealId));
            UserMealsModel usermeals = new UserMealsModel();
            usermeals.setUser(user);
            usermeals.setMeal(meal);
            usermeals.setCreatedAt(request.getCreated());
            saveRecords.add(uMealsRepository.save(usermeals));
        }

        return saveRecords.stream()
                      .map(MealMapper::toUserMealDTO)
                      .collect(Collectors.toList());
    }

    @Override
    public void deleteRecordMeal(int recordId) {
        uMealsRepository.deleteById(recordId);
    }

    @Override
    public void deleteAllRecordMeal(String userId, LocalDate targetDate) {
        uMealsRepository.deleteAllByUserIdAndCreatedAtDate(userId, targetDate);
    }

    @Override
    public List<MealsModel> searchByMealName(String mealName) {
        List<MealsModel> meals = mealRepository.findByMealNameLike("%" + mealName + "%");
        if (meals.isEmpty()) {
            throw new RuntimeException("No meals found for meal name");
        }
        return meals;
    }
}
