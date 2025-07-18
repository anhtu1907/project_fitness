package com.example.Project4.services.exercise;

import java.util.List;

import com.example.Project4.payload.exercise.ExerciseFavoriteRequest;
import com.example.Project4.payload.exercise.ExerciseScheduleRequest;
import com.example.Project4.payload.exercise.ExerciseSessionBatchRequest;
import com.example.Project4.payload.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.dto.exercise.EquipmentsDTO;
import com.example.Project4.dto.exercise.ExerciseCategoryDTO;
import com.example.Project4.dto.exercise.ExerciseFavoriteDTO;
import com.example.Project4.dto.exercise.ExerciseProgressDTO;
import com.example.Project4.dto.exercise.ExerciseScheduleDTO;
import com.example.Project4.dto.exercise.ExerciseSessionDTO;
import com.example.Project4.dto.exercise.ExerciseSubCategoryDTO;
import com.example.Project4.dto.exercise.ExerciseSubCategoryProgramDTO;
import com.example.Project4.dto.exercise.ExerciseUserDTO;
import com.example.Project4.dto.exercise.ExercisesDTO;
import com.example.Project4.dto.exercise.FavoritesDTO;
import com.example.Project4.models.exercise.ExerciseModeModel;
import com.example.Project4.models.exercise.ExercisesModel;

public interface ExerciseService {
    List<ExerciseSubCategoryProgramDTO> getAllSubCategoryProgam();

    List<ExerciseModeModel> getAllExerciseMode();

    List<ExercisesDTO> getAllExercise();

    List<ExerciseCategoryDTO> getAllCategory();

    List<ExerciseSubCategoryDTO> getAllSubCategory();

    List<ExercisesDTO> getExerciseBySubCategoryId(int subCategoryId);

    ExercisesModel getExerciseById(int exerciseId);

    List<ExerciseProgressDTO> getAllExerciseProgressByUserId(int userId);

    List<ExerciseSessionDTO> getAllExerciseSessionByUserId(int userId);

    List<ExerciseUserDTO> getAllExerciseResultByUserId(int userId);

    boolean findByIdAndUserId(int scheduleId, int userId);

    void deleteExerciseSchdedule(int scheduleId);

    void deleteAllExerciseScheduleByTime();

    // Schedule
    ExerciseProgressDTO startMultipleExercises(ExerciseSessionBatchRequest req);

    List<ExerciseScheduleDTO> getAllScheduleByUserId(int userId);

    ExerciseScheduleDTO scheduleExercise(ExerciseScheduleRequest req);

    ExerciseScheduleDTO updateScheduleExercise(ExerciseUpdateScheduleRequest req);

    // Favorite
    List<FavoritesDTO> getAllFavoriteByUserId(int userId);

    List<ExerciseFavoriteDTO> getAllExerciseFavoriteByUserId(int userId, int favoriteId);

    FavoritesDTO addNewFavoriteByUserId(int userId, String favoriteName);

    ExerciseFavoriteDTO addExerciseFavoriteByUserId(ExerciseFavoriteRequest req, int userId);

    void removeFavorite(int favoriteId);

    void removeExerciseFavorite(int subCategoryId);
    int getResetBatchBySubCategory(int userId, int subCategoryId);


    // Search
    List<ExerciseSubCategoryDTO> searchBySubCategoryName(String subCategoryName);

    // Equipment
    List<EquipmentsDTO> getAllEquipmentBySubCategoryId(int subCategoryId);

    List<EquipmentsDTO> getAllEquipment();
}
