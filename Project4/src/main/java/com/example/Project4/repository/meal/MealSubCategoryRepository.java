package com.example.Project4.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.meal.MealSubCategoryModel;

@Repository
public interface MealSubCategoryRepository extends JpaRepository<MealSubCategoryModel, Integer> {
    
}
