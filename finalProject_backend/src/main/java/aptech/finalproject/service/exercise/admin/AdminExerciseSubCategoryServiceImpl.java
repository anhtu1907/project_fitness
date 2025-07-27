package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseSubCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSubCategoryResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.exercise.ExerciseSubCategoryModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseSubCategoryMapper;
import aptech.finalproject.repository.exercise.ExerciseSubCategoryRepository;
import aptech.finalproject.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminExerciseSubCategoryServiceImpl implements AdminExerciseSubCategoryService {

    private final ExerciseSubCategoryRepository repository;
    private final ExerciseSubCategoryMapper mapper;
    private final FileService fileService;

    
    public List<ExerciseSubCategoryResponse> getAll() {
        return repository.findAll().stream()
                .map(mapper::toResponse)
                .collect(Collectors.toList());
    }

    
    public ExerciseSubCategoryResponse getById(int id) {
        ExerciseSubCategoryModel entity = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND));
        return mapper.toResponse(entity);
    }

    
    public ExerciseSubCategoryResponse create(ExerciseSubCategoryRequest request) {
        ExerciseSubCategoryModel entity = mapper.toEntity(request);

        if (request.getSubCategoryImage() != null && !request.getSubCategoryImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getSubCategoryImage(), Optional.of("exercise"));
            entity.setSubCategoryImage(fileMetadata.getStoredName());
        }

        return mapper.toResponse(repository.save(entity));
    }

    
    public ExerciseSubCategoryResponse update(int id, ExerciseSubCategoryRequest request) {
        ExerciseSubCategoryModel existing = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND));

        mapper.updateEntity(existing, request);

        if (request.getSubCategoryImage() != null && !request.getSubCategoryImage().isEmpty()) {
            // Optional: delete old image if exists
            if (existing.getSubCategoryImage() != null) {
                fileService.deleteImage(existing.getSubCategoryImage());
            }

            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getSubCategoryImage(), Optional.of("exercise"));
            existing.setSubCategoryImage(fileMetadata.getStoredName());
        }

        return mapper.toResponse(repository.save(existing));
    }

    
    public void delete(int id) {
        ExerciseSubCategoryModel entity = repository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND));

        // Optional: delete associated image
        if (entity.getSubCategoryImage() != null) {
            fileService.deleteImage(entity.getSubCategoryImage());
        }

        repository.delete(entity);
    }
}

