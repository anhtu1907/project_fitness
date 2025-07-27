package aptech.finalproject.controller.exercise.admin;


import aptech.finalproject.dto.request.exercise.ExerciseSubCategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseSubCategoryResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseSubCategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-sub-category")
@RequiredArgsConstructor
public class AdminExerciseSubCategoryController {

    private final AdminExerciseSubCategoryService service;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExerciseSubCategoryResponse> create(@ModelAttribute @Valid ExerciseSubCategoryRequest request,
                                                           BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        ExerciseSubCategoryResponse created = service.create(request);
        return ApiResponse.created(created, "Created exercise subcategory");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExerciseSubCategoryResponse> update(@PathVariable int id,
                                                           @ModelAttribute @Valid ExerciseSubCategoryRequest request,
                                                           BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        ExerciseSubCategoryResponse updated = service.update(id, request);
        return ApiResponse.ok(updated, "Updated exercise subcategory");
    }

    @GetMapping
    public ApiResponse<List<ExerciseSubCategoryResponse>> getAll() {
        List<ExerciseSubCategoryResponse> list = service.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_SUBCATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise subcategories");
    }

    @GetMapping("/{id}")
    public ApiResponse<ExerciseSubCategoryResponse> getById(@PathVariable int id) {
        ExerciseSubCategoryResponse response = service.getById(id);
        return ApiResponse.ok(response, "Get exercise subcategory by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        service.delete(id);
        return ApiResponse.noContent("Deleted exercise subcategory with id " + id);
    }
}
