package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseCategoryResponse;

import java.util.List;

public interface ExerciseCategoryService {
    ExerciseCategoryResponse createCategory(ExerciseCategoryRequest request);
    ExerciseCategoryResponse updateCategory(int id, ExerciseCategoryRequest request);
    ExerciseCategoryResponse getCategoryById(int id);
    List<ExerciseCategoryResponse> getAllCategories();
    void deleteCategory(int id);
}
