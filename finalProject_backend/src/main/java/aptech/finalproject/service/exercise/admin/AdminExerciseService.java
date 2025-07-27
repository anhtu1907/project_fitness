package aptech.finalproject.service.exercise.admin;

import aptech.finalproject.dto.request.exercise.ExercisesRequest;
import aptech.finalproject.dto.response.exercise.ExercisesResponse;

import java.util.List;

public interface AdminExerciseService {

    List<ExercisesResponse> getAllExercises();

    public ExercisesResponse getExerciseById(int id);

    ExercisesResponse createExercise(ExercisesRequest request);

    ExercisesResponse updateExercise(int id, ExercisesRequest request);

    void deleteExercise(int id);

    List<ExercisesResponse> searchExercisesByName(String name);

}