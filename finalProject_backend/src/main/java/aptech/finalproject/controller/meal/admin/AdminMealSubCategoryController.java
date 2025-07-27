package aptech.finalproject.controller.meal.admin;

import aptech.finalproject.dto.request.meal.MealSubCategoryRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.meal.MealSubCategoryResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.meal.admin.AdminMealSubCategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/meal-subcategory")
public class AdminMealSubCategoryController {

    @Autowired
    private AdminMealSubCategoryService subCategoryService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealSubCategoryResponse> create(@ModelAttribute @Valid MealSubCategoryRequest request,
                                                       BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealSubCategoryResponse response = subCategoryService.create(request);
        return ApiResponse.created(response, "Created meal subcategory successfully.");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealSubCategoryResponse> update(@PathVariable Integer id,
                                                       @ModelAttribute @Valid MealSubCategoryRequest request,
                                                       BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealSubCategoryResponse response = subCategoryService.update(id, request);
        return ApiResponse.ok(response, "Updated meal subcategory successfully.");
    }

    @GetMapping("/{id}")
    public ApiResponse<MealSubCategoryResponse> getById(@PathVariable Integer id) {
        MealSubCategoryResponse response = subCategoryService.getById(id);
        return ApiResponse.ok(response, "Fetched meal subcategory by id.");
    }

    @GetMapping
    public ApiResponse<List<MealSubCategoryResponse>> getAll() {
        List<MealSubCategoryResponse> subCategories = subCategoryService.getAll();
        if (subCategories.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.MEAL_SUBCATEGORY_NOT_FOUND.getException());
        }
        return ApiResponse.ok(subCategories, "Fetched all meal subcategories.");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        subCategoryService.deleteById(id);
        return ApiResponse.noContent("Deleted meal subcategory successfully.");
    }
}

