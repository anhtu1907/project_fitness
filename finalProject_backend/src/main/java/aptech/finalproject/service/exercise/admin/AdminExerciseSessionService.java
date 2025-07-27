package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseSessionRequest;
import aptech.finalproject.dto.response.exercise.ExerciseSessionResponse;

import java.util.List;

public interface AdminExerciseSessionService {
    ExerciseSessionResponse create(ExerciseSessionRequest request);
    ExerciseSessionResponse update(int id, ExerciseSessionRequest request);
    ExerciseSessionResponse getById(int id);
    List<ExerciseSessionResponse> getAll();
    void delete(int id);
}
