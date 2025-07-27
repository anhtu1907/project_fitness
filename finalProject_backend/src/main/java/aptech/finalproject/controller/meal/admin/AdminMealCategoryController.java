package aptech.finalproject.controller.meal.admin;

import aptech.finalproject.dto.request.meal.MealCategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.meal.MealCategoryResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.meal.admin.AdminMealCategoryServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/meal-category")
public class AdminMealCategoryController {

    @Autowired
    private AdminMealCategoryServiceImpl mealCategoryService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealCategoryResponse> create(@ModelAttribute @Valid MealCategoryRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealCategoryResponse response = mealCategoryService.create(request);
        return ApiResponse.created(response, "Created meal category");
    }

    @PutMapping(value ="/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealCategoryResponse> update(@PathVariable Integer id,
                                                    @ModelAttribute @Valid MealCategoryRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealCategoryResponse response = mealCategoryService.update(id, request);
        return ApiResponse.ok(response, "Updated meal category");
    }

    @GetMapping("/{id}")
    public ApiResponse<MealCategoryResponse> getById(@PathVariable Integer id) {
        MealCategoryResponse response = mealCategoryService.getById(id);
        return ApiResponse.ok(response, "Get meal category by id");
    }

    @GetMapping()
    public ApiResponse<List<MealCategoryResponse>> getAll() {
        List<MealCategoryResponse> responseList = mealCategoryService.getAll();
        if (responseList.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.MEAL_CATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(responseList, "Get all meal categories");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        mealCategoryService.deleteById(id);
        return ApiResponse.noContent(String.format("Deleted meal category with id %s", id));
    }
}
