package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.Project4.entity.exercise.ExerciseSubCategoryModel;

@Repository
public interface ExerciseSubCategoryRepository extends JpaRepository<ExerciseSubCategoryModel, Integer> {
    List<ExerciseSubCategoryModel> findBySubCategoryNameLike(String subCategoryName);
}
