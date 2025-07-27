package aptech.finalproject.controller.meal.admin;

import aptech.finalproject.dto.request.meal.MealTimeRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.meal.MealTimeResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.meal.admin.AdminMealTimeServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/meal-times")
public class AdminMealTimeController {

    @Autowired
    private AdminMealTimeServiceImpl mealTimeService;

    @PostMapping("/create")
    public ApiResponse<MealTimeResponse> create(@RequestBody @Valid MealTimeRequest request,
                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealTimeResponse response = mealTimeService.create(request);
        return ApiResponse.created(response, "Created meal time successfully.");
    }

    @PutMapping("/{id}")
    public ApiResponse<MealTimeResponse> update(@PathVariable Integer id,
                                                @RequestBody @Valid MealTimeRequest request,
                                                BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        MealTimeResponse response = mealTimeService.update(id, request);
        return ApiResponse.ok(response, "Updated meal time successfully.");
    }

    @GetMapping("/{id}")
    public ApiResponse<MealTimeResponse> getById(@PathVariable Integer id) {
        MealTimeResponse response = mealTimeService.getById(id);
        return ApiResponse.ok(response, "Fetched meal time by id.");
    }

    @GetMapping
    public ApiResponse<List<MealTimeResponse>> getAll() {
        List<MealTimeResponse> times = mealTimeService.getAll();
        if (times.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.MEAL_TIME_NOT_FOUND.getException());
        }
        return ApiResponse.ok(times, "Fetched all meal times.");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        mealTimeService.deleteById(id);
        return ApiResponse.noContent("Deleted meal time successfully.");
    }
}

