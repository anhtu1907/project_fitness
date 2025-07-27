package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.MealSubCategoryRequest;
import aptech.finalproject.dto.response.meal.MealSubCategoryResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.meal.MealCategoryModel;
import aptech.finalproject.entity.meal.MealSubCategoryModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.meal.MealSubCategoryMapper;
import aptech.finalproject.repository.FileMetadataRepository;
import aptech.finalproject.repository.meal.MealCategoryRepository;
import aptech.finalproject.repository.meal.MealSubCategoryRepository;
import aptech.finalproject.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminMealSubCategoryServiceImpl implements AdminMealSubCategoryService {

    private final MealSubCategoryRepository subCategoryRepository;
    private final MealCategoryRepository categoryRepository;
    private final MealSubCategoryMapper subCategoryMapper;
    private final FileService fileService;
    private final FileMetadataRepository fileMetadataRepository;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealSubCategoryResponse create(MealSubCategoryRequest request) {
        MealSubCategoryModel subCategory = subCategoryMapper.toEntity(request);

        // Gán category
        MealCategoryModel category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_CATEGORY_NOT_FOUND));
        subCategory.setCategory(category);

        // Lưu hình ảnh nếu có
        if (request.getSubCategoryImage() != null && !request.getSubCategoryImage().isEmpty()) {
            FileMetadata image = fileService.saveFileByOriginal(request.getSubCategoryImage(), Optional.of("meal-subcategory"));
            subCategory.setSubCategoryImage(image.getStoredName());
        }

        return subCategoryMapper.toResponse(subCategoryRepository.save(subCategory));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealSubCategoryResponse update(Integer id, MealSubCategoryRequest request) {
        MealSubCategoryModel existing = subCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND));

        subCategoryMapper.update(existing, request);

        // Cập nhật category
        MealCategoryModel category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_CATEGORY_NOT_FOUND));
        existing.setCategory(category);

        // Cập nhật hình ảnh nếu có
        if (request.getSubCategoryImage() != null && !request.getSubCategoryImage().isEmpty()) {
            FileMetadata image = fileService.saveFileByOriginal(request.getSubCategoryImage(), Optional.of("meal-subcategory"));
            existing.setSubCategoryImage(image.getStoredName());
        }

        return subCategoryMapper.toResponse(subCategoryRepository.save(existing));
    }

    public MealSubCategoryResponse getById(Integer id) {
        MealSubCategoryModel subCategory = subCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND));
        return subCategoryMapper.toResponse(subCategory);
    }

    public List<MealSubCategoryResponse> getAll() {
        return subCategoryRepository.findAll()
                .stream()
                .map(subCategoryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Integer id) {
        if (!subCategoryRepository.existsById(id)) {
            throw new ApiException(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND);
        }
        subCategoryRepository.deleteById(id);
    }
}
