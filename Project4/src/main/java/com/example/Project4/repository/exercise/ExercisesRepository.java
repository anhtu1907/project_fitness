package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import com.example.Project4.models.exercise.ExercisesModel;

@Repository
public interface ExercisesRepository extends JpaRepository<ExercisesModel,Integer>{
    List<ExercisesModel> findAllBySubCategoryId(int subCategoryId);
    long countBySubCategoryId(int subCategoryId);
}
