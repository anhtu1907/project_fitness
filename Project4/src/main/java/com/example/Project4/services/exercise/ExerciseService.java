package com.example.Project4.services.exercise;

import java.util.List;


import com.example.Project4.dto.ExerciseSessionRequest;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoyrModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;

public interface ExerciseService {
    List<ExercisesModel> getAllExercise();
    List<ExerciseCategoryModel> getAllCategory();
    List<ExerciseSubCategoyrModel> getAllSubCategory();
    List<ExercisesModel> getExerciseBySubCategoryId(int subCategoryId);
    ExercisesModel getExerciseById(int exerciseId);
    List<ExerciseProgressModel> getAllExerciseProgressByUserId(int userId);
    List<ExerciseSessionModel> getAllExerciseSessionByUserId(int userId);
    List<ExerciseUserModel> getAllExerciseResultByUserId(int userId);
    ExerciseProgressModel startExercise(ExerciseSessionRequest req);
}
