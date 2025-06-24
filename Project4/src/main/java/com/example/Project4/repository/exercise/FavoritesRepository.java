package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.models.exercise.FavoritesModel;

public interface FavoritesRepository extends JpaRepository<FavoritesModel,Integer>{
    
    List<FavoritesModel> findAllFavoriteByUserId(int userId);
}
