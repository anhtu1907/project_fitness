package com.example.Project4.service.exercise;

import java.util.List;

import com.example.Project4.payload.exercise.*;
import com.example.Project4.dto.exercise.*;
import com.example.Project4.entity.exercise.*;

public interface ExerciseService {
    List<ExerciseSubCategoryProgramDTO> getAllSubCategoryProgam();

    List<ExerciseModeDTO> getAllExerciseMode();

    List<ExercisesDTO> getAllExercise();

    List<ExerciseCategoryDTO> getAllCategory();

    List<ExerciseSubCategoryDTO> getAllSubCategory();

    List<ExercisesDTO> getExerciseBySubCategoryId(int subCategoryId);

    ExercisesModel getExerciseById(int exerciseId);

    List<ExerciseProgressDTO> getAllExerciseProgressByUserId(String userId);

    List<ExerciseSessionDTO> getAllExerciseSessionByUserId(String userId);

    List<ExerciseUserDTO> getAllExerciseResultByUserId(String userId);

    boolean findByIdAndUserId(int scheduleId, String userId);

    void deleteExerciseSchdedule(int scheduleId);

    void deleteAllExerciseScheduleByTime();

    // Schedule
    ExerciseProgressDTO startMultipleExercises(ExerciseSessionBatchRequest req);

    List<ExerciseScheduleDTO> getAllScheduleByUserId(String userId);

    ExerciseScheduleDTO scheduleExercise(ExerciseScheduleRequest req);

    ExerciseScheduleDTO updateScheduleExercise(ExerciseUpdateScheduleRequest req);

    // Favorite
    List<FavoritesDTO> getAllFavoriteByUserId(String userId);

    List<ExerciseFavoriteDTO> getAllExerciseFavoriteByUserId(String userId, int favoriteId);

    FavoritesDTO addNewFavoriteByUserId(String userId, String favoriteName);

    ExerciseFavoriteDTO addExerciseFavoriteByUserId(ExerciseFavoriteRequest req, String userId);

    void removeFavorite(int favoriteId);

    void removeExerciseFavorite(int subCategoryId);
    int getResetBatchBySubCategory(String userId, int subCategoryId);


    // Search
    List<ExerciseSubCategoryDTO> searchBySubCategoryName(String subCategoryName);

    // Equipment
    List<EquipmentsDTO> getAllEquipmentBySubCategoryId(int subCategoryId);

    List<EquipmentsDTO> getAllEquipment();
}
