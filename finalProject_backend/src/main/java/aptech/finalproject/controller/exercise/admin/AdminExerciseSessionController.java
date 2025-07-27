package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseSessionRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseSessionResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseSessionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-session")
@RequiredArgsConstructor
public class AdminExerciseSessionController {

    private final AdminExerciseSessionService service;

    @PostMapping("/create")
    public ApiResponse<ExerciseSessionResponse> create(@RequestBody @Valid ExerciseSessionRequest request,
                                                       BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseSessionResponse created = service.create(request);
        return ApiResponse.created(created, "Created exercise session");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseSessionResponse> update(@PathVariable int id,
                                                       @RequestBody @Valid ExerciseSessionRequest request,
                                                       BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseSessionResponse updated = service.update(id, request);
        return ApiResponse.ok(updated, "Updated exercise session");
    }

    @GetMapping
    public ApiResponse<List<ExerciseSessionResponse>> getAll() {
        List<ExerciseSessionResponse> list = service.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_SESSION_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise sessions");
    }

    @GetMapping("/{id}")
    public ApiResponse<ExerciseSessionResponse> getById(@PathVariable int id) {
        ExerciseSessionResponse response = service.getById(id);
        return ApiResponse.ok(response, "Get exercise session by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        service.delete(id);
        return ApiResponse.noContent("Deleted exercise session with id " + id);
    }
}

