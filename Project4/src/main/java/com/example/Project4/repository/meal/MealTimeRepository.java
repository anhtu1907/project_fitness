package com.example.Project4.repository.meal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.meal.MealTimeModel;

@Repository
public interface MealTimeRepository extends JpaRepository<MealTimeModel,Integer> {
    
}
