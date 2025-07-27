package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseModeRequest;
import aptech.finalproject.dto.response.exercise.ExerciseModeResponse;

import java.util.List;

public interface AdminExerciseModeService {
    ExerciseModeResponse create(ExerciseModeRequest request);
    ExerciseModeResponse update(int id, ExerciseModeRequest request);
    ExerciseModeResponse getById(int id);
    List<ExerciseModeResponse> getAll();
    void delete(int id);
}
