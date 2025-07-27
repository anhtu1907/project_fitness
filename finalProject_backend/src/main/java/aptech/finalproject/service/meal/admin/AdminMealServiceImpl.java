package aptech.finalproject.service.meal.admin;

import aptech.finalproject.dto.request.meal.MealsRequest;
import aptech.finalproject.dto.response.meal.MealsResponse;
import aptech.finalproject.entity.auth.FileMetadata;
import aptech.finalproject.entity.meal.MealsModel;

import aptech.finalproject.exception.ApiException;
import aptech.finalproject.exception.ErrorCode;

import aptech.finalproject.mapper.meal.MealsMapper;
import aptech.finalproject.repository.meal.MealSubCategoryRepository;
import aptech.finalproject.repository.meal.MealTimeRepository;
import aptech.finalproject.repository.meal.MealsRepository;
import aptech.finalproject.service.FileService;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminMealServiceImpl implements AdminMealService {

    private final MealsRepository mealsRepository;
    private final MealSubCategoryRepository subCategoryRepository;
    private final MealTimeRepository timeRepository;
    private final MealsMapper mealsMapper;
    private final FileService fileService;

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealsResponse createMeal(MealsRequest request) {
        MealsModel meal = mealsMapper.toEntity(request);

        // Map subcategories
        if (request.getSubCategoryIds() != null) {
            meal.setSubCategory(
                    request.getSubCategoryIds().stream()
                            .map(id -> subCategoryRepository.findById(id)
                                    .orElseThrow(() -> new ApiException(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND)))
                            .collect(Collectors.toSet())
            );
        }

        // Map time of day
        if (request.getTimeOfDayIds() != null) {
            meal.setTimeOfDay(
                    request.getTimeOfDayIds().stream()
                            .map(id -> timeRepository.findById(id)
                                    .orElseThrow(() -> new ApiException(ErrorCode.MEAL_TIME_NOT_FOUND)))
                            .collect(Collectors.toSet())
            );
        }

        // Upload image if provided
        MultipartFile image = request.getMealImage();
        if (image != null && !image.isEmpty()) {
            FileMetadata metadata = fileService.saveFileByOriginal(image, Optional.of("meal"));
            meal.setMealImage(metadata.getStoredName());
        }

        return mealsMapper.toResponse(mealsRepository.save(meal));
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public MealsResponse updateMeal(Integer id, MealsRequest request) {
        MealsModel existing = mealsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_NOT_FOUND));

        mealsMapper.update(existing, request);

        // Update subcategories
        if (request.getSubCategoryIds() != null) {
            existing.setSubCategory(
                    request.getSubCategoryIds().stream()
                            .map(subId -> subCategoryRepository.findById(subId)
                                    .orElseThrow(() -> new ApiException(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND)))
                            .collect(Collectors.toSet())
            );
        }

        // Update time of day
        if (request.getTimeOfDayIds() != null) {
            existing.setTimeOfDay(
                    request.getTimeOfDayIds().stream()
                            .map(timeId -> timeRepository.findById(timeId)
                                    .orElseThrow(() -> new ApiException(ErrorCode.MEAL_TIME_NOT_FOUND)))
                            .collect(Collectors.toSet())
            );
        }

        // Update image if provided
        MultipartFile image = request.getMealImage();
        if (image != null && !image.isEmpty()) {
            FileMetadata metadata = fileService.saveFileByOriginal(image, Optional.of("meal"));
            existing.setMealImage(metadata.getStoredName());
        }

        return mealsMapper.toResponse(mealsRepository.save(existing));
    }

    public MealsResponse getById(Integer id) {
        MealsModel meal = mealsRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.MEAL_NOT_FOUND));
        return mealsMapper.toResponse(meal);
    }

    public List<MealsResponse> getAllMeals() {
        return mealsRepository.findAll().stream()
                .map(mealsMapper::toResponse)
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAuthority('MANAGE_PRODUCTS')")
    public void deleteById(Integer id) {
        if (!mealsRepository.existsById(id)) {
            throw new ApiException(ErrorCode.MEAL_NOT_FOUND);
        }
        mealsRepository.deleteById(id);
    }
}

