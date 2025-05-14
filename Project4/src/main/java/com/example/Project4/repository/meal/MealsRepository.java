package com.example.Project4.repository.meal;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.meal.MealsModel;

@Repository
public interface MealsRepository extends JpaRepository<MealsModel,Integer> {
    List<MealsModel> findAllBySubCategoryId(int subCategoryId);
    List<MealsModel> findByMealNameLike(String mealName);
}
