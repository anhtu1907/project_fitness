package com.example.Project4.repository.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.exercise.ExerciseSubCategoyrModel;

@Repository
public interface ExerciseSubCategoryRepository extends JpaRepository<ExerciseSubCategoyrModel, Integer> {
    
}
