package com.example.Project4.repository.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.models.exercise.ExerciseModeModel;

@Repository
public interface ExerciseModeRepository extends JpaRepository<ExerciseModeModel,Integer>{
    
}
