package com.example.Project4.services.exercise;

import java.util.List;

import com.example.Project4.payload.exercise.ExerciseFavoriteRequest;
import com.example.Project4.payload.exercise.ExerciseScheduleRequest;
import com.example.Project4.payload.exercise.ExerciseSessionRequest;
import com.example.Project4.payload.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseFavoriteModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoyrModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;
import com.example.Project4.models.exercise.FavoritesModel;

public interface ExerciseService {
    List<ExercisesModel> getAllExercise();
    List<ExerciseCategoryModel> getAllCategory();
    List<ExerciseSubCategoyrModel> getAllSubCategory();
    List<ExercisesModel> getExerciseBySubCategoryId(int subCategoryId);
    ExercisesModel getExerciseById(int exerciseId);
    List<ExerciseProgressModel> getAllExerciseProgressByUserId(int userId);
    List<ExerciseSessionModel> getAllExerciseSessionByUserId(int userId);
    List<ExerciseUserModel> getAllExerciseResultByUserId(int userId);
    List<ExerciseScheduleModel> getAllScheduleByUserId(int userId);
    ExerciseProgressModel startExercise(ExerciseSessionRequest req);
    ExerciseScheduleModel scheduleExercise(ExerciseScheduleRequest req);
    ExerciseScheduleModel updateScheduleExercise(ExerciseUpdateScheduleRequest req);
    boolean findByIdAndUserId(int scheduleId, int userId);
    void deleteExerciseSchdedule(int scheduleId);
    void deleteAllExerciseScheduleByTime();
    // Favorite
    List<FavoritesModel> getAllFavoriteByUserId(int userId);
    List<ExerciseFavoriteModel> getAllExerciseFavoriteByUserId(int userId, int favoriteId);
    FavoritesModel addNewFavoriteByUserId(int userId, String favoriteName);
    ExerciseFavoriteModel addExerciseFavoriteByUserId(ExerciseFavoriteRequest req ,int userId);
    void removeFavorite(int favoriteId);
    void removeExerciseFavorite(int subCategoryId);
}
