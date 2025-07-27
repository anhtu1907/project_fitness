package aptech.finalproject.controller.meal.admin;

import aptech.finalproject.dto.request.meal.UserMealsRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.meal.UserMealsResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.meal.admin.AdminUserMealServiceImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/user-meals")
public class AdminUserMealsController {

    @Autowired
    private AdminUserMealServiceImpl userMealService;

    @PostMapping("/create")
    public ApiResponse<UserMealsResponse> create(@RequestBody @Valid UserMealsRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        UserMealsResponse response = userMealService.create(request);
        return ApiResponse.created(response, "Created user meal successfully.");
    }

    @PutMapping("/{id}")
    public ApiResponse<UserMealsResponse> update(@PathVariable Integer id,
                                                 @RequestBody @Valid UserMealsRequest request,
                                                 BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        UserMealsResponse response = userMealService.update(id, request);
        return ApiResponse.ok(response, "Updated user meal successfully.");
    }

    @GetMapping("/{id}")
    public ApiResponse<UserMealsResponse> getById(@PathVariable Integer id) {
        UserMealsResponse response = userMealService.getById(id);
        return ApiResponse.ok(response, "Fetched user meal by id.");
    }

    @GetMapping
    public ApiResponse<List<UserMealsResponse>> getAll() {
        List<UserMealsResponse> list = userMealService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.USER_MEAL_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Fetched all user meals.");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        userMealService.deleteById(id);
        return ApiResponse.noContent("Deleted user meal successfully.");
    }
}

