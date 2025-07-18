package com.example.Project4.repository.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.exercise.ExerciseCategoryModel;

@Repository
public interface ExerciseCategoryRepository extends JpaRepository<ExerciseCategoryModel,Integer>{
    
}
