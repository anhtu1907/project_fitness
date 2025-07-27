package aptech.finalproject.controller.meal.admin;


import aptech.finalproject.dto.request.meal.MealsRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.meal.MealsResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.meal.admin.AdminMealServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/meals")
public class AdminMealController {

    @Autowired
    private AdminMealServiceImpl mealService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealsResponse> create(@ModelAttribute @Valid MealsRequest request,
                                             BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealsResponse response = mealService.createMeal(request);
        return ApiResponse.created(response, "Created meal successfully.");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<MealsResponse> update(@PathVariable Integer id,
                                             @ModelAttribute @Valid MealsRequest request,
                                             BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealsResponse updated = mealService.updateMeal(id, request);
        return ApiResponse.ok(updated, "Updated meal successfully.");
    }

    @GetMapping("/{id}")
    public ApiResponse<MealsResponse> getById(@PathVariable Integer id) {
        MealsResponse response = mealService.getById(id);
        return ApiResponse.ok(response, "Fetched meal by id.");
    }

    @GetMapping
    public ApiResponse<List<MealsResponse>> getAll() {
        List<MealsResponse> meals = mealService.getAllMeals();
        if (meals.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.MEAL_NOT_FOUND.getException());
        }
        return ApiResponse.ok(meals, "Fetched all meals.");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        mealService.deleteById(id);
        return ApiResponse.noContent("Deleted meal successfully.");
    }
}
