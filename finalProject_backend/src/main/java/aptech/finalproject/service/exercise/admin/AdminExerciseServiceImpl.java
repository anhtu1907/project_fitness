package aptech.finalproject.service.exercise.admin;
import aptech.finalproject.dto.request.exercise.ExercisesRequest;
import aptech.finalproject.dto.response.exercise.ExercisesResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.exercise.EquipmentsModel;
import aptech.finalproject.entity.exercise.ExerciseModeModel;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.entity.exercise.ExercisesModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseMapper;
import aptech.finalproject.repository.exercise.EquipmentsRepository;
import aptech.finalproject.repository.exercise.ExerciseModeRepository;
import aptech.finalproject.repository.exercise.ExerciseSubCategoryRepository;
import aptech.finalproject.repository.exercise.ExercisesRepository;
import aptech.finalproject.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AdminExerciseServiceImpl implements AdminExerciseService {

    @Autowired
    private ExercisesRepository exercisesRepository;

    @Autowired
    private ExerciseMapper exerciseMapper;

    @Autowired
    private ExerciseSubCategoryRepository subCategoryRepository;

    @Autowired
    private EquipmentsRepository equipmentsRepository;

    @Autowired
    private ExerciseModeRepository modeRepository;

    @Autowired
    private FileService fileService;

//    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public ExercisesResponse createExercise(ExercisesRequest request) {

        ExercisesModel exercise = exerciseMapper.toEntity(request);

        if (request.getExerciseImage() != null && !request.getExerciseImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getExerciseImage(), Optional.of("exercise"));
            exercise.setExerciseImage(fileMetadata.getStoredName()); //
        }

        // Thiết lập equipment
        if (request.getEquipmentId() != null) {
            EquipmentsModel equipment = equipmentsRepository.findById(request.getEquipmentId())
                    .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));
            exercise.setEquipment(equipment);
        }

        // Thiết lập mode
        if (request.getModeIds() != null && !request.getModeIds().isEmpty()) {
            Set<ExerciseModeModel> modes = request.getModeIds().stream()
                    .map(id -> modeRepository.findById(id)
                            .orElseThrow(() -> {
                                System.out.println("Không tìm thấy ModeId: " + id);
                                return new ApiException(ErrorCode.EXERCISE_MODE_NOT_FOUND);
                            }))
                    .collect(Collectors.toSet());
            exercise.setModes(modes);
        }


        // Thiết lập subCategory
        if (request.getSubCategoryIds() != null) {
            Set<ExerciseSubCategoryModel> subCategories = request.getSubCategoryIds().stream()
                    .map(id -> subCategoryRepository.findById(id)
                            .orElseThrow(() -> {
                                System.out.println("Không tìm thấy SubCategoryId: " + id);
                                return new ApiException(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND);
                            }))
                    .collect(Collectors.toSet());
            exercise.setSubCategory(subCategories);
        }

        return exerciseMapper.toResponse(exercisesRepository.save(exercise));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public ExercisesResponse updateExercise(int id, ExercisesRequest request) {
        ExercisesModel exercise = exercisesRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_NOT_FOUND));

        // Cập nhật dữ liệu đơn giản
        exerciseMapper.updateEntity(exercise, request);

        // Cập nhật file ảnh nếu có
        if (request.getExerciseImage() != null && !request.getExerciseImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getExerciseImage(), Optional.of("exercise"));
            exercise.setExerciseImage(fileMetadata.getStoredName()); // <- lưu storedName
        }

        // Cập nhật equipment
        if( request.getEquipmentId() != null) {
            EquipmentsModel equipment = equipmentsRepository.findById(request.getEquipmentId())
                    .orElseThrow(() -> new ApiException(ErrorCode.EQUIPMENT_NOT_FOUND));
            exercise.setEquipment(equipment);
        }

        // Cập nhật mode
        if (request.getModeIds() != null && !request.getModeIds().isEmpty()) {
            Set<ExerciseModeModel> modes = request.getModeIds().stream()
                    .map(ids -> modeRepository.findById(ids)
                            .orElseThrow(() -> {
                                System.out.println("Not found mode: " + ids);
                                return new ApiException(ErrorCode.EXERCISE_MODE_NOT_FOUND);
                            }))
                    .collect(Collectors.toSet());
            exercise.setModes(modes);
        }

        // Cập nhật subCategory
        if( request.getSubCategoryIds() != null) {
            Set<ExerciseSubCategoryModel> subCategories = request.getSubCategoryIds().stream()
                    .map(ids -> subCategoryRepository.findById(ids)
                            .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND)))
                    .collect(Collectors.toSet());
            exercise.setSubCategory(subCategories);
        }

        return exerciseMapper.toResponse(exercisesRepository.save(exercise));
    }

    public ExercisesResponse getExerciseById(int id) {
        ExercisesModel exercise = exercisesRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_NOT_FOUND));
        return exerciseMapper.toResponse(exercise);
    }

    public List<ExercisesResponse> getAllExercises() {
        return exercisesRepository.findAll().stream()
                .map(exerciseMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteExercise(int id) {
        if (!exercisesRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_NOT_FOUND);
        }
        exercisesRepository.deleteById(id);
    }

    public List<ExercisesResponse> searchExercisesByName(String name) {
        return exercisesRepository.findByExerciseNameContainingIgnoreCase(name).stream()
                .map(exerciseMapper::toResponse)
                .collect(Collectors.toList());
    }


}

