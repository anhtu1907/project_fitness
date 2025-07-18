package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.entity.exercise.ExerciseFavoriteModel;

public interface ExerciseFavoriteRepository extends JpaRepository<ExerciseFavoriteModel, Integer>{
    void deleteBySubCategoryId(int subCategoryId);
    List<ExerciseFavoriteModel> findAllByUserIdAndFavoriteId(String userId, int favoriteId);
} 
