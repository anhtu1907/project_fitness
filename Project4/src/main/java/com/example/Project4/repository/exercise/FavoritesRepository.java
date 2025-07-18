package com.example.Project4.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.Project4.entity.exercise.FavoritesModel;

public interface FavoritesRepository extends JpaRepository<FavoritesModel,Integer>{
    
    List<FavoritesModel> findAllFavoriteByUserId(String userId);
}
