package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseScheduleRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExerciseScheduleResponse;
import aptech.finalproject.exception.ErrorCode;
import aptech.finalproject.service.exercise.admin.AdminExerciseScheduleService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercise-schedule")
public class AdminExerciseScheduleController {

    @Autowired
    private AdminExerciseScheduleService exerciseScheduleService;

    @PostMapping("/create")
    public ApiResponse<ExerciseScheduleResponse> create(@RequestBody @Valid ExerciseScheduleRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseScheduleResponse response = exerciseScheduleService.create(request);
        return ApiResponse.created(response, "Created exercise schedule");
    }

    @PutMapping("/{id}")
    public ApiResponse<ExerciseScheduleResponse> update(@PathVariable int id,
                                                        @RequestBody @Valid ExerciseScheduleRequest request,
                                                        BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExerciseScheduleResponse response = exerciseScheduleService.update(id, request);
        return ApiResponse.ok(response, "Updated exercise schedule");
    }

    @GetMapping
    public ApiResponse<List<ExerciseScheduleResponse>> getAll() {
        List<ExerciseScheduleResponse> list = exerciseScheduleService.getAll();
        if (list.isEmpty()) {
            return ApiResponse.notFound(ErrorCode.EXERCISE_SCHEDULE_NOT_FOUND.getException());
        }
        return ApiResponse.ok(list, "Get all exercise schedules");
    }

    @GetMapping("/id/{id}")
    public ApiResponse<ExerciseScheduleResponse> getById(@PathVariable int id) {
        ExerciseScheduleResponse response = exerciseScheduleService.getById(id);
        return ApiResponse.ok(response, "Get exercise schedule by id");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        exerciseScheduleService.delete(id);
        return ApiResponse.noContent(String.format("Deleted exercise schedule with id %s", id));
    }
}

