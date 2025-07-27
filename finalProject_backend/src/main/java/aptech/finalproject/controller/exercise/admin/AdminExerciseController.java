package aptech.finalproject.controller.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExercisesRequest;
import aptech.finalproject.dto.response.ApiResponse;
import aptech.finalproject.dto.response.exercise.ExercisesResponse;
import aptech.finalproject.service.exercise.admin.AdminExerciseService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/exercises")
public class AdminExerciseController {

    @Autowired
    private AdminExerciseService exerciseService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExercisesResponse> createExercise(@ModelAttribute @Valid ExercisesRequest request,
            BindingResult result) {
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExercisesResponse created = exerciseService.createExercise(request);
        return ApiResponse.created(created, "Exercise created successfully");
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ExercisesResponse> updateExercise(@PathVariable int id,
            @ModelAttribute @Valid ExercisesRequest request,
            BindingResult result) {
                

        System.out.println("🛠️ Controller updateExercise called with id = " + id);
        if (result.hasErrors()) {
            return ApiResponse.badRequest(result);
        }
        ExercisesResponse updated = exerciseService.updateExercise(id, request);
        return ApiResponse.ok(updated, "Exercise updated successfully");
    }

    @GetMapping
    public ApiResponse<List<ExercisesResponse>> getAllExercises() {
        List<ExercisesResponse> list = exerciseService.getAllExercises();
        return ApiResponse.ok(list, "List of all exercises");
    }

    @GetMapping("/{id}")
    public ApiResponse<ExercisesResponse> getExerciseById(@PathVariable int id) {
        ExercisesResponse response = exerciseService.getExerciseById(id);
        return ApiResponse.ok(response, "Exercise found");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteExercise(@PathVariable int id) {
        exerciseService.deleteExercise(id);
        return ApiResponse.noContent("Exercise deleted successfully");
    }

    @GetMapping("/search")
    public ApiResponse<List<ExercisesResponse>> searchExercises(@RequestParam String name) {
        List<ExercisesResponse> results = exerciseService.searchExercisesByName(name);
        return ApiResponse.ok(results, "Exercises search result");
    }

}
