package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.exercise.ExercisesModel;

@Repository
public interface ExercisesRepository extends JpaRepository<ExercisesModel,Integer>{
    List<ExercisesModel> findAllBySubCategoryId(int subCategoryId);
    long countBySubCategoryId(int subCategoryId);
    @Query("SELECT DISTINCT e FROM ExercisesModel e LEFT JOIN FETCH e.subCategory LEFT JOIN FETCH e.modes")
List<ExercisesModel> findAllWithSubCategoryAndModes();
}
