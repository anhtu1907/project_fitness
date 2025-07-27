package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseScheduleRequest;
import aptech.finalproject.dto.response.exercise.ExerciseScheduleResponse;

import java.util.List;

public interface AdminExerciseScheduleService {
    ExerciseScheduleResponse create(ExerciseScheduleRequest request);
    ExerciseScheduleResponse update(int id, ExerciseScheduleRequest request);
    ExerciseScheduleResponse getById(int id);
    List<ExerciseScheduleResponse> getAll();
    void delete(int id);
}
