package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseModeRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseModeResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseModeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-mode")
public class AdminExerciseModeController {

    @Autowired
    private AdminExerciseModeService exerciseModeService;

    @PostMapping("/create")
    public ApiResponse<ExerciseModeResponse> create(@RequestBody @Valid ExerciseModeRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseModeResponse response = exerciseModeService.create(request);
        return ApiResponse.created(response, "Created exercise mode");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseModeResponse> update(@PathVariable int id,
                                                    @RequestBody @Valid ExerciseModeRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseModeResponse response = exerciseModeService.update(id, request);
        return ApiResponse.ok(response, "Updated exercise mode");
    }

    @GetMapping
    public ApiResponse<List<ExerciseModeResponse>> getAll() {
        List<ExerciseModeResponse> list = exerciseModeService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_MODE_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise modes");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ExerciseModeResponse> getById(@PathVariable int id) {
        ExerciseModeResponse response = exerciseModeService.getById(id);
        return ApiResponse.ok(response, "Get exercise mode by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        exerciseModeService.delete(id);
        return ApiResponse.noContent(String.format("Deleted exercise mode with id %s", id));
    }
}
