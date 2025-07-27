package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgressRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgressResponse;

import java.util.List;

public interface AdminExerciseProgressService {
    ExerciseProgressResponse create(ExerciseProgressRequest request);
    ExerciseProgressResponse update(int id, ExerciseProgressRequest request);
    ExerciseProgressResponse getById(int id);
    List<ExerciseProgressResponse> getAll();
    void delete(int id);
}
