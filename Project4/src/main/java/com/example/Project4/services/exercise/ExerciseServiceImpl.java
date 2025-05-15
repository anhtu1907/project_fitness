package com.example.Project4.services.exercise;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.dto.exercise.ExerciseScheduleRequest;
import com.example.Project4.dto.exercise.ExerciseSessionRequest;
import com.example.Project4.dto.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoyrModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;
import com.example.Project4.repository.exercise.ExerciseCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseProgressRepository;
import com.example.Project4.repository.exercise.ExerciseScheduleRepository;
import com.example.Project4.repository.exercise.ExerciseSessionRepository;
import com.example.Project4.repository.exercise.ExerciseSubCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseUserRepository;
import com.example.Project4.repository.exercise.ExercisesRepository;

@Service
public class ExerciseServiceImpl implements ExerciseService {
    @Autowired
    private ExercisesRepository exercisesRepository;
    @Autowired
    private ExerciseCategoryRepository exerciseCategoryRepository;
    @Autowired
    private ExerciseSubCategoryRepository exerciseSubCategoryRepository;
    @Autowired
    private ExerciseProgressRepository exerciseProgressRepository;
    @Autowired
    private ExerciseUserRepository exerciseUserRepository;
    @Autowired
    private ExerciseSessionRepository exerciseSessionRepository;
    @Autowired
    private ExerciseScheduleRepository exerciseScheduleRepository;

    @Override
    public List<ExerciseCategoryModel> getAllCategory() {
        return exerciseCategoryRepository.findAll();
    }

    @Override
    public List<ExercisesModel> getAllExercise() {
        return exercisesRepository.findAll();
    }

    @Override
    public List<ExerciseProgressModel> getAllExerciseProgressByUserId(int userId) {
        return exerciseProgressRepository.findAllProgressByUserId(userId);
    }

    @Override
    public List<ExerciseUserModel> getAllExerciseResultByUserId(int userId) {
        return exerciseUserRepository.findAllExerciseByUserId(userId);
    }

    @Override
    public List<ExerciseSessionModel> getAllExerciseSessionByUserId(int userId) {
        return exerciseSessionRepository.findAllSessionByUserId(userId);
    }

    @Override
    public List<ExerciseSubCategoyrModel> getAllSubCategory() {
        return exerciseSubCategoryRepository.findAll();
    }

    @Override
    public ExercisesModel getExerciseById(int exerciseId) {
        ExercisesModel exercises = exercisesRepository.findById(exerciseId)
                .orElseThrow(() -> new RuntimeException("Exercise not found with id: " + exerciseId));
        return exercises;
    }

    @Override
    public List<ExercisesModel> getExerciseBySubCategoryId(int subCategoryId) {
        return exercisesRepository.findAllBySubCategoryId(subCategoryId);
    }

    @Override
    public ExerciseProgressModel startExercise(ExerciseSessionRequest req) {
        ExercisesModel exercises = exercisesRepository.findById(req.getExerciseId())
                .orElseThrow(() -> new RuntimeException("Exercise not found"));

        List<ExerciseSessionModel> existingSession = exerciseSessionRepository
                .findByUserAndExerciseAndResetBatch(req.getUserId(), req.getExerciseId(), req.getResetBatch());

        if (!existingSession.isEmpty()) {
            throw new RuntimeException(
                    "You have already performed this exercise in the current rest batch. Please reset the batch to continue.");
        }

        ExerciseSubCategoyrModel subCategory = exercises.getSubCategory();

        // Tạo mới ExerciseSession
        ExerciseSessionModel newSession = new ExerciseSessionModel();
        UserModel user = new UserModel();
        user.setId(req.getUserId());
        newSession.setUser(user);
        newSession.setExercise(exercises);
        newSession.setKcal(exercises.getKcal());
        newSession.setDuration(req.getDuration());
        newSession.setResetBatch(req.getResetBatch());
        newSession.setCreatedAt(LocalDateTime.now());
        exerciseSessionRepository.save(newSession);

        // Tạo mới ExerciseUser
        ExerciseUserModel exerciseUser = new ExerciseUserModel();
        exerciseUser.setUser(user);
        exerciseUser.setSession(newSession);
        exerciseUser.setKcal(newSession.getKcal());
        exerciseUser.setCreatedAt(LocalDateTime.now());
        exerciseUserRepository.save(exerciseUser);

        // Tạo mới ExerciseProgress
        ExerciseProgressModel exerciseProgress = new ExerciseProgressModel();
        exerciseProgress.setUser(user);
        exerciseProgress.setExercise(newSession);

        long totalExerciseInCategory = exercisesRepository.countBySubCategoryId(subCategory.getId());
        long completedExercisesInCategory = exerciseSessionRepository
                .countByUserIdAndSubCategoryIdAndResetBatch(req.getUserId(), subCategory.getId(), req.getResetBatch());

        double progressPercent = 0.0;
        if (totalExerciseInCategory > 0) {
            progressPercent = ((double) completedExercisesInCategory / totalExerciseInCategory) * 100;
        }

        exerciseProgress.setProgress(progressPercent);
        exerciseProgress.setLastUpdated(LocalDateTime.now());
        exerciseProgressRepository.save(exerciseProgress);

        return exerciseProgress;
    }

    @Override
    public List<ExerciseScheduleModel> getAllScheduleByUserId(int userId) {
        return exerciseScheduleRepository.findAllScheduleByUserId(userId);
    }

    @Override
    public boolean findByIdAndUserId(int scheduleId, int userId) {
        exerciseScheduleRepository.findByIdAndUser_Id(scheduleId, userId)
                .orElseThrow(() -> new RuntimeException("Schedule not found or access denied"));
        return true;
    }

    @Override
    public ExerciseScheduleModel scheduleExercise(ExerciseScheduleRequest req) {
        ExerciseSubCategoyrModel subCategories = exerciseSubCategoryRepository.findById(req.getSubCategory())
                .orElseThrow(() -> new RuntimeException("Sub Category not found"));
        UserModel user = new UserModel();
        ExerciseScheduleModel newSchedule = new ExerciseScheduleModel();
        user.setId(req.getUser());
        newSchedule.setUser(user);
        newSchedule.setSubCategory(subCategories);
        newSchedule.setScheduleTime(req.getScheduleTime());
        exerciseScheduleRepository.save(newSchedule);
        return newSchedule;
    }

    @Override
    public ExerciseScheduleModel updateScheduleExercise(ExerciseUpdateScheduleRequest req) {
        ExerciseScheduleModel existSchedule = exerciseScheduleRepository
                .findById(req.getScheduleId()).orElseThrow(() -> new RuntimeException("Schedule not found"));
        existSchedule.setScheduleTime(req.getScheduleTime());
        exerciseScheduleRepository.save(existSchedule);
        return existSchedule;
    }

    @Override
    public void deleteExerciseSchdedule(int scheduleId) {
        exerciseScheduleRepository.deleteById(scheduleId);
    }
}
