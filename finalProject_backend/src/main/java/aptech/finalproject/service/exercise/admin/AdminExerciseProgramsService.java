package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExerciseProgramsRequest;
import aptech.finalproject.dto.response.exercise.ExerciseProgramsResponse;

import java.util.List;

public interface AdminExerciseProgramsService {
    ExerciseProgramsResponse create(ExerciseProgramsRequest request);
    ExerciseProgramsResponse update(int id, ExerciseProgramsRequest request);
    ExerciseProgramsResponse getById(int id);
    List<ExerciseProgramsResponse> getAll();
    void delete(int id);
}