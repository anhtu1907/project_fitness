package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseCategoryResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.exercise.ExerciseCategoryModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.exercise.ExerciseCategoryMapper;
import aptech.finalproject.repository.exercise.ExerciseCategoryRepository;
import aptech.finalproject.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ExerciseCategoryServiceImpl implements ExerciseCategoryService{

    @Autowired
    private ExerciseCategoryRepository categoryRepository;

    @Autowired
    private ExerciseCategoryMapper categoryMapper;

    @Autowired
    private FileService fileService;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public ExerciseCategoryResponse createCategory(ExerciseCategoryRequest request) {
        ExerciseCategoryModel category = categoryMapper.toEntity(request);

        if (request.getCategoryImage() != null && !request.getCategoryImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getCategoryImage(), Optional.of("exercise"));
            category.setCategoryImage(fileMetadata.getStoredName());
        }

        return categoryMapper.toResponse(categoryRepository.save(category));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public ExerciseCategoryResponse updateCategory(int id, ExerciseCategoryRequest request) {
        ExerciseCategoryModel category = categoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_CATEGORY_NOT_FOUND));

        categoryMapper.updateEntity(category, request);

        if (request.getCategoryImage() != null && !request.getCategoryImage().isEmpty()) {
            FileMetadata fileMetadata = fileService.saveFileByOriginal(request.getCategoryImage(), Optional.of("exercise"));
            category.setCategoryImage(fileMetadata.getStoredName());
        }

        return categoryMapper.toResponse(categoryRepository.save(category));
    }

    public ExerciseCategoryResponse getCategoryById(int id) {
        ExerciseCategoryModel category = categoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.EXERCISE_CATEGORY_NOT_FOUND));
        return categoryMapper.toResponse(category);
    }

    public List<ExerciseCategoryResponse> getAllCategories() {
        return categoryRepository.findAll().stream()
                .map(categoryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteCategory(int id) {
        if (!categoryRepository.existsById(id)) {
            throw new ApiException(ErrorCode.EXERCISE_CATEGORY_NOT_FOUND);
        }
        categoryRepository.deleteById(id);
    }
}