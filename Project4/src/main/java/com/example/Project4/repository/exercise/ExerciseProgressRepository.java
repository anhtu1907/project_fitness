package com.example.Project4.repository.exercise;

import java.util.List;


import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import com.example.Project4.models.exercise.ExerciseProgressModel;

@Repository
public interface ExerciseProgressRepository extends JpaRepository<ExerciseProgressModel, Integer> {
    List<ExerciseProgressModel> findAllProgressByUserId(int userId);
}
