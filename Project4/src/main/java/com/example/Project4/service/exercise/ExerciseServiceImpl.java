package com.example.Project4.service.exercise;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.exercise.*;
import com.example.Project4.dto.exercise.*;
import com.example.Project4.entity.auth.User;
import com.example.Project4.entity.exercise.*;
import com.example.Project4.mapper.ExerciseMapper;
import com.example.Project4.repository.auth.*;
import com.example.Project4.repository.exercise.*;

import jakarta.transaction.Transactional;

@Service
@Transactional
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
    private ExerciseModeRepository exerciseModeRepository;
    @Autowired
    private FavoritesRepository favoritesRepository;
    @Autowired
    private ExerciseSubCategoryProgramRepository categoryProgramRepository;

    @Autowired
    private EquipmentsRepository equipmentRepository;
    @Autowired
    private UserRepository userRepository;

    @Override
    public List<ExerciseCategoryDTO> getAllCategory() {
        return exerciseCategoryRepository.findAll().stream().map(ExerciseMapper::toCategoryDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ExercisesDTO> getAllExercise() {
        return exercisesRepository.findAllWithSubCategoryAndModes().stream().map(ExerciseMapper::toDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseSubCategoryDTO> getAllSubCategory() {
        return exerciseSubCategoryRepository.findAll().stream().map(ExerciseMapper::toSubCategoryDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ExerciseProgressDTO> getAllExerciseProgressByUserId(String userId) {
        return exerciseProgressRepository.findAllProgressByUserId(userId).stream()
                .map(ExerciseMapper::toExerciseProgressDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseUserDTO> getAllExerciseResultByUserId(String userId) {
        return exerciseUserRepository.findAllExerciseByUserId(userId).stream()
                .map(ExerciseMapper::toExerciseUserDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseSessionDTO> getAllExerciseSessionByUserId(String userId) {
        return exerciseSessionRepository.findAllSessionByUserId(userId).stream()
                .map(ExerciseMapper::toSessionDto).collect(Collectors.toList());
    }

    @Override
    public ExercisesModel getExerciseById(int exerciseId) {
        ExercisesModel exercises = exercisesRepository.findById(exerciseId)
                .orElseThrow(() -> new RuntimeException("Exercise not found with id: " + exerciseId));
        return exercises;
    }

    @Override
    public List<ExercisesDTO> getExerciseBySubCategoryId(int subCategoryId) {
        return exercisesRepository.findAllBySubCategoryId(subCategoryId).stream()
                .map(entity -> ExerciseMapper.toDto(entity, subCategoryId))
                .collect(Collectors.toList());
    }

    @Override
    public ExerciseProgressDTO startMultipleExercises(ExerciseSessionBatchRequest req) {
        User user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository
                .findById(req.getSubCategoryId())
                .orElseThrow(() -> new RuntimeException("SubCategory not found"));

        ExerciseProgressModel lastProgressModel = null;

        for (ExerciseSessionRequest sessionReq : req.getSessions()) {
            ExercisesModel exercise = exercisesRepository.findById(sessionReq.getExerciseId())
                    .orElseThrow(() -> new RuntimeException("Exercise not found: " + sessionReq.getExerciseId()));

            boolean exists = !exerciseSessionRepository
                    .findByUserAndExerciseAndResetBatch(user.getId(), exercise.getId(), req.getResetBatch())
                    .isEmpty();

            if (exists)
                continue;

            // ❗️Tính completed trước khi thêm bài mới
            long total = exercisesRepository.countBySubCategoryId(subCategory.getId());
            long completedBefore = exerciseSessionRepository.countByUserIdAndSubCategoryIdAndResetBatch(
                    req.getUserId(), subCategory.getId(), req.getResetBatch());

            double progress = (total > 0)
                    ? ((double) (completedBefore + 1) / total) * 100
                    : 0.0;

            // Tạo session
            ExerciseSessionModel session = new ExerciseSessionModel();
            session.setUser(user);
            session.setExercise(exercise);
            session.setSubCategory(subCategory);
            session.setDuration(sessionReq.getDuration());
            session.setResetBatch(req.getResetBatch());
            session.setKcal(exercise.getKcal());
            session.setCreatedAt(LocalDateTime.now());
            exerciseSessionRepository.save(session);

            // Tạo exercise user
            ExerciseUserModel exerciseUser = new ExerciseUserModel();
            exerciseUser.setUser(user);
            exerciseUser.setSession(session);
            exerciseUser.setKcal(session.getKcal());
            exerciseUser.setCreatedAt(LocalDateTime.now());
            exerciseUserRepository.save(exerciseUser);

            // Lưu progress tương ứng
            ExerciseProgressModel progressModel = new ExerciseProgressModel();
            progressModel.setUser(user);
            progressModel.setExercise(session);
            progressModel.setProgress(progress);
            progressModel.setLastUpdated(LocalDateTime.now());
            exerciseProgressRepository.save(progressModel);

            lastProgressModel = progressModel;
        }

        if (lastProgressModel != null) {
            return ExerciseMapper.toExerciseProgressDto(lastProgressModel);
        } else {
            throw new RuntimeException("No new sessions created");
        }
    }

    @Override
    public List<ExerciseScheduleDTO> getAllScheduleByUserId(String userId) {
        return exerciseScheduleRepository.findAllScheduleByUserId(userId).stream().map(ExerciseMapper::toScheduleDto)
                .collect(Collectors.toList());
    }

    @Override
    public boolean findByIdAndUserId(int scheduleId, String userId) {
        exerciseScheduleRepository.findByIdAndUser_Id(scheduleId, userId)
                .orElseThrow(() -> new RuntimeException("Schedule not found or access denied"));
        return true;
    }

    @Override
    public ExerciseScheduleDTO scheduleExercise(ExerciseScheduleRequest req) {
        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository.findById(req.getSubCategory())
                .orElseThrow(() -> new RuntimeException("Sub Category not found"));
        User user = userRepository.findById(req.getUser())
                .orElseThrow(() -> new RuntimeException("User not found"));
        ExerciseScheduleModel newSchedule = new ExerciseScheduleModel();
        newSchedule.setUser(user);
        newSchedule.setSubCategory(subCategory);
        newSchedule.setScheduleTime(req.getScheduleTime());
        exerciseScheduleRepository.save(newSchedule);
        return ExerciseMapper.toScheduleDto(newSchedule);
    }

    @Override
    public ExerciseScheduleDTO updateScheduleExercise(ExerciseUpdateScheduleRequest req) {
        ExerciseScheduleModel existSchedule = exerciseScheduleRepository
                .findById(req.getScheduleId()).orElseThrow(() -> new RuntimeException("Schedule not found"));
        existSchedule.setScheduleTime(req.getScheduleTime());
        exerciseScheduleRepository.save(existSchedule);
        return ExerciseMapper.toScheduleDto(existSchedule);
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
    public List<FavoritesDTO> getAllFavoriteByUserId(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return favoritesRepository.findAllFavoriteByUserId(user.getId()).stream().map(ExerciseMapper::toFavoritesDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ExerciseFavoriteDTO> getAllExerciseFavoriteByUserId(
            String userId, int favoriteId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel favorite = favoritesRepository.findById(favoriteId)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        return exerciseFavoriteRepository.findAllByUserIdAndFavoriteId(user.getId(), favorite.getId()).stream()
                .map(ExerciseMapper::toExerciseFavoriteDTO)
                .collect(Collectors.toList());
    }

    @Override
    public FavoritesDTO addNewFavoriteByUserId(String userId, String favoriteName) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel newFavorite = new FavoritesModel();
        newFavorite.setUser(user);
        newFavorite.setFavoriteName(favoriteName);
        FavoritesModel saved = favoritesRepository.save(newFavorite);
        return ExerciseMapper.toFavoritesDto(saved);
    }

    @Override
    public ExerciseFavoriteDTO addExerciseFavoriteByUserId(ExerciseFavoriteRequest req, String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel favorite = favoritesRepository.findById(req.getFavorite())
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository.findById(req.getSubCategory())
                .orElseThrow(() -> new RuntimeException("SubCategory not found"));
        ExerciseFavoriteModel newExercise = new ExerciseFavoriteModel();
        newExercise.setFavorite(favorite);
        newExercise.setSubCategory(subCategory);
        newExercise.setUser(user);
        return ExerciseMapper.toExerciseFavoriteDTO(exerciseFavoriteRepository.save(newExercise));
    }

    @Override
    @Transactional
    public void removeExerciseFavorite(int subCategoryId) {
        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository.findById(subCategoryId)
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

    @Override
    public List<ExerciseSubCategoryProgramDTO> getAllSubCategoryProgam() {
        return categoryProgramRepository.findAll().stream().map(ExerciseMapper::toSubCategoryProgramDto).toList();
    }

    @Override
    public List<ExerciseModeDTO> getAllExerciseMode() {
        return exerciseModeRepository.findAll().stream().map(ExerciseMapper::toModeDto).collect(Collectors.toList());
    }

    // Search
    @Override
    public List<ExerciseSubCategoryDTO> searchBySubCategoryName(String subCategoryName) {
        List<ExerciseSubCategoryModel> subCategoires = exerciseSubCategoryRepository
                .findBySubCategoryNameLike("%" + subCategoryName + "%");
        if (subCategoires.isEmpty()) {
            throw new RuntimeException("No sub category found for subcategory name");
        }
        return subCategoires.stream().map(ExerciseMapper::toSubCategoryDto).collect(Collectors.toList());
    }

    // Equipment
    @Override
    public List<EquipmentsDTO> getAllEquipmentBySubCategoryId(int subCategoryId) {
        List<EquipmentsModel> listEquipment = equipmentRepository.getAllEquipmentBySubCategoryId(subCategoryId);
        return listEquipment.stream().map(ExerciseMapper::toEquipmentsDto).collect(Collectors.toList());
    }

    @Override
    public List<EquipmentsDTO> getAllEquipment() {
        return equipmentRepository.findAll().stream().map(ExerciseMapper::toEquipmentsDto).collect(Collectors.toList());
    }

    @Override
    public int getResetBatchBySubCategory(String userId, int subCategoryId) {
        int batch = 0;
        int maxBatch = 1000;
        while (batch < maxBatch) {
            long completedCount = exerciseSessionRepository.countCompletedInSubCategory(userId, subCategoryId, batch);
            long totalExercises = exercisesRepository.countBySubCategoryId(subCategoryId);
            if (completedCount < totalExercises) {
                return batch;
            }
            batch++;
        }
        throw new RuntimeException("Too many resetBatch loops. Check data integrity.");
    }
}
