package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import aptech.finalproject.entity.exercise.ExerciseFavoriteModel;

public interface ExerciseFavoriteRepository extends JpaRepository<ExerciseFavoriteModel, Integer>{
    void deleteBySubCategoryId(int subCategoryId);
    List<ExerciseFavoriteModel> findAllByUserIdAndFavoriteId(String userId, int favoriteId);
    List<ExerciseFavoriteModel> findByUserId(String userId);
} 
