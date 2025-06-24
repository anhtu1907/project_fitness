package com.example.Project4.services.exercise;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.exercise.ExerciseFavoriteRequest;
import com.example.Project4.payload.exercise.ExerciseScheduleRequest;
import com.example.Project4.payload.exercise.ExerciseSessionRequest;
import com.example.Project4.payload.exercise.ExerciseUpdateScheduleRequest;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.exercise.ExerciseCategoryModel;
import com.example.Project4.models.exercise.ExerciseFavoriteModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoyrModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;
import com.example.Project4.models.exercise.FavoritesModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.exercise.ExerciseCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseFavoriteRepository;
import com.example.Project4.repository.exercise.ExerciseProgressRepository;
import com.example.Project4.repository.exercise.ExerciseScheduleRepository;
import com.example.Project4.repository.exercise.ExerciseSessionRepository;
import com.example.Project4.repository.exercise.ExerciseSubCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseUserRepository;
import com.example.Project4.repository.exercise.ExercisesRepository;
import com.example.Project4.repository.exercise.FavoritesRepository;

import jakarta.transaction.Transactional;

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
    @Autowired
    private ExerciseFavoriteRepository exerciseFavoriteRepository;
    @Autowired
    private FavoritesRepository favoritesRepository;

    @Autowired
    private UserRepository userRepository;

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

        UserModel user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<ExerciseSessionModel> existingSession = exerciseSessionRepository
                .findByUserAndExerciseAndResetBatch(req.getUserId(), req.getExerciseId(), req.getResetBatch());

        if (!existingSession.isEmpty()) {
            throw new RuntimeException(
                    "You have already performed this exercise in the current rest batch. Please reset the batch to continue.");
        }

        ExerciseSubCategoyrModel subCategory = exercises.getSubCategory();

        // Tạo mới ExerciseSession
        ExerciseSessionModel newSession = new ExerciseSessionModel();
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
        UserModel user = userRepository.findById(req.getUser())
                .orElseThrow(() -> new RuntimeException("User not found"));
        ExerciseScheduleModel newSchedule = new ExerciseScheduleModel();
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

    @Override
    public void deleteAllExerciseScheduleByTime() {
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        List<ExerciseScheduleModel> schedules = exerciseScheduleRepository.findAllByScheduleTimeBefore(startOfDay);
        for (ExerciseScheduleModel schedule : schedules) {

            exerciseScheduleRepository.delete(schedule);

        }
    }

    // Favorite
    @Override
    public List<FavoritesModel> getAllFavoriteByUserId(int userId) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return favoritesRepository.findAllFavoriteByUserId(user.getId());
    }
    @Override
    public List<ExerciseFavoriteModel> getAllExerciseFavoriteByUserId(
            int userId,int favoriteId) {
         UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
                FavoritesModel favorite = favoritesRepository.findById(favoriteId)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        return exerciseFavoriteRepository.findAllByUserIdAndFavoriteId(user.getId(), favorite.getId());
    }

    @Override
    public FavoritesModel addNewFavoriteByUserId(int userId, String favoriteName) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel newFavorite = new FavoritesModel();
        newFavorite.setUser(user);
        newFavorite.setFavoriteName(favoriteName);
        favoritesRepository.save(newFavorite);
        return newFavorite;
    }

    @Override
    public ExerciseFavoriteModel addExerciseFavoriteByUserId(ExerciseFavoriteRequest req, int userId) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        ExerciseSubCategoyrModel subCategory = exerciseSubCategoryRepository.findById(req.getSubCategory())
                .orElseThrow(() -> new RuntimeException("Sub Category not found"));
                 FavoritesModel favorite = favoritesRepository.findById(req.getFavorite())
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        ExerciseFavoriteModel newExercise = new ExerciseFavoriteModel();
        newExercise.setFavorite(favorite);
        newExercise.setSubCategory(subCategory);
        newExercise.setUser(user);
        exerciseFavoriteRepository.save(newExercise);
        return null;
    }

    @Override
    @Transactional
    public void removeExerciseFavorite(int subCategoryId) {
        ExerciseSubCategoyrModel subCategory = exerciseSubCategoryRepository.findById(subCategoryId)
                .orElseThrow(() -> new RuntimeException("Sub Category not found"));

        exerciseFavoriteRepository.deleteBySubCategoryId(subCategory.getId());
    }

    @Override
    @Transactional
    public void removeFavorite(int favoriteId) {
        FavoritesModel favorite = favoritesRepository.findById(favoriteId)
                .orElseThrow(() -> new RuntimeException("Favorite Not Found"));
        favoritesRepository.delete(favorite);
    }
}
