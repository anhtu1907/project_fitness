package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseSubCategoryRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSubCategoryResponse;

import java.util.List;

public interface AdminExerciseSubCategoryService {
    ExerciseSubCategoryResponse create(ExerciseSubCategoryRequest request);
    ExerciseSubCategoryResponse update(int id, ExerciseSubCategoryRequest request);
    ExerciseSubCategoryResponse getById(int id);
    List<ExerciseSubCategoryResponse> getAll();
    void delete(int id);
}
