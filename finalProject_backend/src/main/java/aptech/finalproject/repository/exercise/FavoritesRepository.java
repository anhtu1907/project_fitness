package aptech.finalproject.repository.exercise;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import aptech.finalproject.entity.exercise.FavoritesModel;

public interface FavoritesRepository extends JpaRepository<FavoritesModel,Integer>{
    
    List<FavoritesModel> findAllFavoriteByUserId(String userId);
}
