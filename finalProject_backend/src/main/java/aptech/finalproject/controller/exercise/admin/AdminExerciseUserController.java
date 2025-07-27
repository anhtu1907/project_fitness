package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseUserRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseUserResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseUserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-user")
@RequiredArgsConstructor
public class AdminExerciseUserController {

    private final AdminExerciseUserService service;

    @PostMapping("/create")
    public ApiResponse<ExerciseUserResponse> create(@RequestBody @Valid ExerciseUserRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        ExerciseUserResponse created = service.create(request);
        return ApiResponse.created(created, "Created exercise user");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseUserResponse> update(@PathVariable int id,
                                                    @RequestBody @Valid ExerciseUserRequest request,
                                                    BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }

        ExerciseUserResponse updated = service.update(id, request);
        return ApiResponse.ok(updated, "Updated exercise user");
    }

    @GetMapping
    public ApiResponse<List<ExerciseUserResponse>> getAll() {
        List<ExerciseUserResponse> list = service.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_USER_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise users");
    }

    @GetMapping("/{id}")
    public ApiResponse<ExerciseUserResponse> getById(@PathVariable int id) {
        ExerciseUserResponse response = service.getById(id);
        return ApiResponse.ok(response, "Get exercise user by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        service.delete(id);
        return ApiResponse.noContent("Deleted exercise user with id " + id);
    }
}
