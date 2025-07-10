package com.example.Project4.services.exercise;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.Project4.payload.exercise.ExerciseFavoriteRequest;
import com.example.Project4.payload.exercise.ExerciseScheduleRequest;
import com.example.Project4.payload.exercise.ExerciseSessionRequest;
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
import com.example.Project4.mapper.ExerciseMapper;
import com.example.Project4.models.auth.UserModel;
import com.example.Project4.models.exercise.EquipmentsModel;
import com.example.Project4.models.exercise.ExerciseFavoriteModel;
import com.example.Project4.models.exercise.ExerciseModeModel;
import com.example.Project4.models.exercise.ExerciseProgressModel;
import com.example.Project4.models.exercise.ExerciseScheduleModel;
import com.example.Project4.models.exercise.ExerciseSessionModel;
import com.example.Project4.models.exercise.ExerciseSubCategoryModel;
import com.example.Project4.models.exercise.ExerciseUserModel;
import com.example.Project4.models.exercise.ExercisesModel;
import com.example.Project4.models.exercise.FavoritesModel;
import com.example.Project4.repository.auth.UserRepository;
import com.example.Project4.repository.exercise.EquipmentsRepository;
import com.example.Project4.repository.exercise.ExerciseCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseFavoriteRepository;
import com.example.Project4.repository.exercise.ExerciseModeRepository;
import com.example.Project4.repository.exercise.ExerciseProgressRepository;
import com.example.Project4.repository.exercise.ExerciseScheduleRepository;
import com.example.Project4.repository.exercise.ExerciseSessionRepository;
import com.example.Project4.repository.exercise.ExerciseSubCategoryProgramRepository;
import com.example.Project4.repository.exercise.ExerciseSubCategoryRepository;
import com.example.Project4.repository.exercise.ExerciseUserRepository;
import com.example.Project4.repository.exercise.ExercisesRepository;
import com.example.Project4.repository.exercise.FavoritesRepository;

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
        return exercisesRepository.findAll().stream().map(ExerciseMapper::toDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseSubCategoryDTO> getAllSubCategory() {
        return exerciseSubCategoryRepository.findAll().stream().map(ExerciseMapper::toSubCategoryDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ExerciseProgressDTO> getAllExerciseProgressByUserId(int userId) {
        return exerciseProgressRepository.findAllProgressByUserId(userId).stream()
                .map(ExerciseMapper::toExerciseProgressDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseUserDTO> getAllExerciseResultByUserId(int userId) {
        return exerciseUserRepository.findAllExerciseByUserId(userId).stream()
                .map(ExerciseMapper::toExerciseUserDto).collect(Collectors.toList());
    }

    @Override
    public List<ExerciseSessionDTO> getAllExerciseSessionByUserId(int userId) {
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
    public ExerciseProgressDTO startExercise(ExerciseSessionRequest req) {
        ExercisesModel exercises = exercisesRepository.findById(req.getExerciseId())
                .orElseThrow(() -> new RuntimeException("Exercise not found"));

        UserModel user = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<ExerciseSessionModel> existingSession = exerciseSessionRepository
                .findByUserAndExerciseAndResetBatch(req.getUserId(), req.getExerciseId(), req.getResetBatch());
        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository
                .findById(req.getSubCategoryId())
                .orElseThrow(() -> new RuntimeException("SubCategory not found"));
        if (!existingSession.isEmpty()) {
            throw new RuntimeException(
                    "You have already performed this exercise in the current rest batch. Please reset the batch to continue.");
        }

        Set<ExerciseSubCategoryModel> subCategories = exercises.getSubCategory();
        double totalProgress = 0.0;
        int count = 0;
        // Tạo mới ExerciseSession
        ExerciseSessionModel newSession = new ExerciseSessionModel();
        newSession.setUser(user);
        newSession.setExercise(exercises);
        newSession.setKcal(exercises.getKcal());
        newSession.setSubCategory(subCategory);
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

        for (ExerciseSubCategoryModel subCat : subCategories) {
            long totalExerciseInCategory = exercisesRepository.countBySubCategoryId(subCat.getId());
            long completedExercisesInCategory = exerciseSessionRepository
                    .countByUserIdAndSubCategoryIdAndResetBatch(req.getUserId(), subCat.getId(),
                            req.getResetBatch());

            double progressPercent = 0.0;
            if (totalExerciseInCategory > 0) {
                progressPercent = ((double) completedExercisesInCategory / totalExerciseInCategory) * 100;
            }

            totalProgress += progressPercent;
            count++;
        }
        double progress = count > 0 ? totalProgress / count : 0.0;

        exerciseProgress.setProgress(progress);
        exerciseProgress.setLastUpdated(LocalDateTime.now());
        exerciseProgressRepository.save(exerciseProgress);

        return ExerciseMapper.toExerciseProgressDto(exerciseProgress);
    }

    @Override
    public List<ExerciseScheduleDTO> getAllScheduleByUserId(int userId) {
        return exerciseScheduleRepository.findAllScheduleByUserId(userId).stream().map(ExerciseMapper::toScheduleDto)
                .collect(Collectors.toList());
    }

    @Override
    public boolean findByIdAndUserId(int scheduleId, int userId) {
        exerciseScheduleRepository.findByIdAndUser_Id(scheduleId, userId)
                .orElseThrow(() -> new RuntimeException("Schedule not found or access denied"));
        return true;
    }

    @Override
    public ExerciseScheduleDTO scheduleExercise(ExerciseScheduleRequest req) {
        ExerciseSubCategoryModel subCategory = exerciseSubCategoryRepository.findById(req.getSubCategory())
                .orElseThrow(() -> new RuntimeException("Sub Category not found"));
        UserModel user = userRepository.findById(req.getUser())
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
    public List<FavoritesDTO> getAllFavoriteByUserId(int userId) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return favoritesRepository.findAllFavoriteByUserId(user.getId()).stream().map(ExerciseMapper::toFavoritesDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ExerciseFavoriteDTO> getAllExerciseFavoriteByUserId(
            int userId, int favoriteId) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel favorite = favoritesRepository.findById(favoriteId)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        return exerciseFavoriteRepository.findAllByUserIdAndFavoriteId(user.getId(), favorite.getId()).stream()
                .map(ExerciseMapper::toExerciseFavoriteDTO)
                .collect(Collectors.toList());
    }

    @Override
    public FavoritesDTO addNewFavoriteByUserId(int userId, String favoriteName) {
        UserModel user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        FavoritesModel newFavorite = new FavoritesModel();
        newFavorite.setUser(user);
        newFavorite.setFavoriteName(favoriteName);
        FavoritesModel saved = favoritesRepository.save(newFavorite);
        return ExerciseMapper.toFavoritesDto(saved);
    }

    @Override
    public ExerciseFavoriteDTO addExerciseFavoriteByUserId(ExerciseFavoriteRequest req, int userId) {
        UserModel user = userRepository.findById(userId)
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
    public List<ExerciseModeModel> getAllExerciseMode() {
        return exerciseModeRepository.findAll();
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
        if (listEquipment.isEmpty()) {
            throw new RuntimeException("No equipment for sub category exercise");
        }
        return listEquipment.stream().map(ExerciseMapper::toEquipmentsDto).collect(Collectors.toList());
    }

    @Override
    public List<EquipmentsDTO> getAllEquipment() {
        return equipmentRepository.findAll().stream().map(ExerciseMapper::toEquipmentsDto).collect(Collectors.toList());
    }

    // @Override
    // public List<EquipmentsDTO> getAllExerciseEquipment() {
    //     return equipmentRepository.getAllExerciseEquipment().stream().map(ExerciseMapper::toEquipmentsDto)
    //             .collect(Collectors.toList());
    // }
}
