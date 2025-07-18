package com.example.Project4.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.meal.MealCategoryModel;

@Repository
public interface MealCategoryRepository extends JpaRepository<MealCategoryModel, Integer>{
    
}
