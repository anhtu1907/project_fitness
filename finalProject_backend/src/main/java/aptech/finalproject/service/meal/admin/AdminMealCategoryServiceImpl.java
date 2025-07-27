package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.MealCategoryRequest;
import aptech.finalproject.dto.response.meal.MealCategoryResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.meal.MealCategoryModel;
import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.mapper.meal.MealCategoryMapper;
import aptech.finalproject.repository.meal.MealCategoryRepository;
import aptech.finalproject.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminMealCategoryServiceImpl implements AdminMealCategoryService {

    private final MealCategoryRepository mealCategoryRepository;
    private final MealCategoryMapper mealCategoryMapper;
    private final FileService fileService;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealCategoryResponse create(MealCategoryRequest request) {
        MealCategoryModel category = mealCategoryMapper.toEntity(request);

        if (request.getCategoryImage() != null && !request.getCategoryImage().isEmpty()) {
            // Nếu dùng chuỗi
            String savedFileName = fileService.saveFileByOriginal(request.getCategoryImage(), Optional.of("meal-category")).getStoredName();
            category.setCategoryImage(savedFileName);
//             FileMetadata image = fileService.saveFileByOriginal(request.getCategoryImage(), Optional.of("meal-category"));
//             category.setCategoryImage(image.getStoredName());
        }

        return mealCategoryMapper.toResponse(mealCategoryRepository.save(category));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealCategoryResponse update(Integer id, MealCategoryRequest request) {
        MealCategoryModel existing = mealCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_CATEGORY_NOT_FOUND));

        mealCategoryMapper.update(existing, request);

        if (request.getCategoryImage() != null && !request.getCategoryImage().isEmpty()) {
            String savedFileName = fileService.saveFileByOriginal(request.getCategoryImage(), Optional.of("meal-category")).getStoredName();
            existing.setCategoryImage(savedFileName);
        }

        return mealCategoryMapper.toResponse(mealCategoryRepository.save(existing));
    }

    public MealCategoryResponse getById(Integer id) {
        MealCategoryModel category = mealCategoryRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_CATEGORY_NOT_FOUND));
        return mealCategoryMapper.toResponse(category);
    }

    public List<MealCategoryResponse> getAll() {
        return mealCategoryRepository.findAll()
                .stream()
                .map(mealCategoryMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Integer id) {
        if (!mealCategoryRepository.existsById(id)) {
            throw new ApiException(ErrorCode.MEAL_CATEGORY_NOT_FOUND);
        }
        mealCategoryRepository.deleteById(id);
    }
}
