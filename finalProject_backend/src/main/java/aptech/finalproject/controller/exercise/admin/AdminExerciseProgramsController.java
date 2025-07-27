package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgramsRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseProgramsResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseProgramsService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-program")
public class AdminExerciseProgramsController {

    @Autowired
    private AdminExerciseProgramsService exerciseProgramsService;

    @PostMapping("/create")
    public ApiResponse<ExerciseProgramsResponse> create(@RequestBody @Valid ExerciseProgramsRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseProgramsResponse response = exerciseProgramsService.create(request);
        return ApiResponse.created(response, "Created exercise program");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseProgramsResponse> update(@PathVariable int id,
                                                        @RequestBody @Valid ExerciseProgramsRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseProgramsResponse response = exerciseProgramsService.update(id, request);
        return ApiResponse.ok(response, "Updated exercise program");
    }

    @GetMapping
    public ApiResponse<List<ExerciseProgramsResponse>> getAll() {
        List<ExerciseProgramsResponse> list = exerciseProgramsService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_PROGRAM_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise programs");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ExerciseProgramsResponse> getById(@PathVariable int id) {
        ExerciseProgramsResponse response = exerciseProgramsService.getById(id);
        return ApiResponse.ok(response, "Get exercise program by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        exerciseProgramsService.delete(id);
        return ApiResponse.noContent(String.format("Deleted exercise program with id %s", id));
    }
}

