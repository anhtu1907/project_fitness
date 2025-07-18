package com.example.Project4.repository.exercise;



import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.exercise.ExerciseUserModel;

@Repository
public interface ExerciseUserRepository extends JpaRepository<ExerciseUserModel,Integer> {
    List<ExerciseUserModel> findAllExerciseByUserId(String userId);
}
