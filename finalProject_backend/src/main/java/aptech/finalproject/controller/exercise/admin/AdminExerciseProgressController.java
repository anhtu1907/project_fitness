package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgressRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseProgressResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseProgressService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-progress")
public class AdminExerciseProgressController {

    @Autowired
    private AdminExerciseProgressService exerciseProgressService;

    @PostMapping("/create")
    public ApiResponse<ExerciseProgressResponse> create(@RequestBody @Valid ExerciseProgressRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseProgressResponse response = exerciseProgressService.create(request);
        return ApiResponse.created(response, "Created exercise progress");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseProgressResponse> update(@PathVariable int id,
                                                        @RequestBody @Valid ExerciseProgressRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseProgressResponse response = exerciseProgressService.update(id, request);
        return ApiResponse.ok(response, "Updated exercise progress");
    }

    @GetMapping
    public ApiResponse<List<ExerciseProgressResponse>> getAll() {
        List<ExerciseProgressResponse> list = exerciseProgressService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_PROGRESS_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise progresses");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ExerciseProgressResponse> getById(@PathVariable int id) {
        ExerciseProgressResponse response = exerciseProgressService.getById(id);
        return ApiResponse.ok(response, "Get exercise progress by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        exerciseProgressService.delete(id);
        return ApiResponse.noContent(String.format("Deleted exercise progress with id %s", id));
    }
}

