package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseUserRequest;
import aptech.finalproject.dto.response.exercise.ExerciseUserResponse;

import java.util.List;

public interface AdminExerciseUserService {
    List<ExerciseUserResponse> getAll();
    ExerciseUserResponse getById(int id);
    ExerciseUserResponse create(ExerciseUserRequest request);
    ExerciseUserResponse update(int id, ExerciseUserRequest request);
    void delete(int id);
}
