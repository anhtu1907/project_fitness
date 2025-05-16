package com.example.Project4.services.exercise;

import java.util.List;

import com.example.Project4.dto.exercise.ExerciseScheduleRequest;
import com.example.Project4.dto.exercise.ExerciseSessionRequest;
import com.example.Project4.dto.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
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
    List<ExerciseScheduleModel> getAllScheduleByUserId(int userId);
    ExerciseProgressModel startExercise(ExerciseSessionRequest req);
    ExerciseScheduleModel scheduleExercise(ExerciseScheduleRequest req);
    ExerciseScheduleModel updateScheduleExercise(ExerciseUpdateScheduleRequest req);
    boolean findByIdAndUserId(int scheduleId, int userId);
    void deleteExerciseSchdedule(int scheduleId);
    void deleteAllExerciseScheduleByTime();
}
