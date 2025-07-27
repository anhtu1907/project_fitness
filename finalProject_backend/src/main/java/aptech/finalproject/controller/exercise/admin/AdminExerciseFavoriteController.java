package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseFavoriteRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseFavoriteResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseFavoriteService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-favorite")
public class AdminExerciseFavoriteController {

    @Autowired
    private AdminExerciseFavoriteService exerciseFavoriteService;

    @PostMapping("/create")
    public ApiResponse<ExerciseFavoriteResponse> create(@RequestBody @Valid ExerciseFavoriteRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseFavoriteResponse response = exerciseFavoriteService.create(request);
        return ApiResponse.created(response, "Created exercise favorite");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseFavoriteResponse> update(@PathVariable int id,
                                                        @RequestBody @Valid ExerciseFavoriteRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseFavoriteResponse response = exerciseFavoriteService.update(id, request);
        return ApiResponse.ok(response, "Updated exercise favorite");
    }

    @GetMapping
    public ApiResponse<List<ExerciseFavoriteResponse>> getAll() {
        List<ExerciseFavoriteResponse> list = exerciseFavoriteService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise favorites");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ExerciseFavoriteResponse> getById(@PathVariable int id) {
        ExerciseFavoriteResponse response = exerciseFavoriteService.getById(id);
        return ApiResponse.ok(response, "Get exercise favorite by id");
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<ExerciseFavoriteResponse>> getByUserId(@PathVariable String userId) {
        List<ExerciseFavoriteResponse> list = exerciseFavoriteService.getByUserId(userId);
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_FAVORITE_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get exercise favorites by userId");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        exerciseFavoriteService.delete(id);
        return ApiResponse.noContent(String.format("Deleted exercise favorite with id %s", id));
    }
}
