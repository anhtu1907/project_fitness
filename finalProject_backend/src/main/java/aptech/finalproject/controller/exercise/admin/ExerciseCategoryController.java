package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseCategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseCategoryResponse;
import aptech.finalproject.service.exercise.admin.ExerciseCategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-categories")
public class ExerciseCategoryController {

    @Autowired
    private ExerciseCategoryService categoryService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExerciseCategoryResponse> createCategory(@ModelAttribute @Valid ExerciseCategoryRequest request,
                                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseCategoryResponse created = categoryService.createCategory(request);
        return ApiResponse.created(created, "Exercise category created successfully");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExerciseCategoryResponse> updateCategory(@PathVariable int id,
                                                                @ModelAttribute @Valid ExerciseCategoryRequest request,
                                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseCategoryResponse updated = categoryService.updateCategory(id, request);
        return ApiResponse.ok(updated, "Exercise category updated successfully");
    }

    @GetMapping
    public ApiResponse<List<ExerciseCategoryResponse>> getAllCategories() {
        List<ExerciseCategoryResponse> list = categoryService.getAllCategories();
        return ApiResponse.ok(list, "List of all exercise categories");
    }

    @GetMapping("/{id}")
    public ApiResponse<ExerciseCategoryResponse> getCategoryById(@PathVariable int id) {
        ExerciseCategoryResponse response = categoryService.getCategoryById(id);
        return ApiResponse.ok(response, "Exercise category found");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteCategory(@PathVariable int id) {
        categoryService.deleteCategory(id);
        return ApiResponse.noContent("Exercise category deleted successfully");
    }
}